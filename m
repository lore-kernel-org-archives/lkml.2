Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099Ab2DKD7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 23:59:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53580 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760065Ab2DKD7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 23:59:47 -0400
Message-ID: <4F8501B0.1070908@zytor.com>
Date: Tue, 10 Apr 2012 20:59:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-kernel@vger.kernel.org, hjl.tools@gmail.com
Subject: Re: Trying to make a working kernel with the gold linker
References: <E1SHnDZ-0006Za-Kh@tytso-glaptop.cam.corp.google.com>
In-Reply-To: <E1SHnDZ-0006Za-Kh@tytso-glaptop.cam.corp.google.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 07:23 PM, Theodore Ts'o wrote:
> So I was trying to see if I could make the kernel build with the gold
> linker (since until it can, I can't install it on my system).
> 
> I saw a message from HJ indicating one of the problems was x86_64 gold
> used an incompatible max-page-size setting, so I tried changing it in
> hopes that would make a bootable kernel.
> 
> No dice, it didn't work.  (At least not with a 2.20 binutils-gold.)
> 
> Does anybody know what the other issues with the gold linker?  Is the
> 2.22 binutils-gold more likely to work?

It would also be kind of nice if the ELF image generated for the kernel
didn't contain several megabytes of zero that serve no purpose and have
to be decompressed at boot time...

	-hpa

