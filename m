Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab0CaGaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:30:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53287 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496Ab0CaGaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:30:20 -0400
Message-ID: <4BB2EB1B.8090303@zytor.com>
Date: Tue, 30 Mar 2010 23:26:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 09:49 PM, James Morris wrote:
> Please make NO_BOOTMEM default to n, at least for amd64, where I've found 
> that it leads to all kinds of strange, undebuggable boot hangs and errors 
> (with relatively current Fedora development userland).

Have you tested it with the latest fixes that are now in Linus' tree (-rc3)?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

