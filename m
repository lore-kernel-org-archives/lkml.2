Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1BIVTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:19:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44958 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab1BIVTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:19:51 -0500
Message-ID: <4D5304F2.7000404@zytor.com>
Date: Wed, 09 Feb 2011 13:19:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: linux-kernel@vger.kernel.org, Lasse Collin <lasse.collin@tukaani.org>
Subject: Re: CONFIG_KERNEL_XZ obscure build failure if xz(1) not installed
References: <20110209195258.GN11874@hexapodia.org>
In-Reply-To: <20110209195258.GN11874@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 11:52 AM, Andy Isaacson wrote:
> 
> The failure is obscured by trailing make output, and since a broken
> bzImage is created, "make install" succeeds, and the first visible
> failure is after reboot when I get the lovely
> 
>     Decompressing Linux...
> 
>     Input is not in the XZ format (wrong magic bytes)
> 
>      -- System halted
> 
> Sometimes I run "make -j4 && make install" which would have caught this,
> but the error should be more prominent and we shouldn't create bzImage
> if the dependencies are not present.
> 

Agreed that the bzImage should not have been created.  That should make
the error prominent enough (your complaint that it gets obscured with
make -j is "just how things work, sorry.")

	-hpa
