Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab1GNVO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:14:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45049 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1GNVOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:14:25 -0400
Message-ID: <4E1F5C20.8000008@zytor.com>
Date: Thu, 14 Jul 2011 14:14:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "John Z. Bohach" <jzb2@aexorsyst.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: large initramfs causes h/w reset after decompressing
References: <201107140906.46404.jzb2@aexorsyst.com>
In-Reply-To: <201107140906.46404.jzb2@aexorsyst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 09:06 AM, John Z. Bohach wrote:
> I have a large initramfs cpio file, about 890 MB, which expands to 2.7 
> GB, and am running on linux-2.6.36.1, in 64-bit mode with 8 GB of 
> physical RAM.
> 
> Upon loading the initramfs, I see the message "Decompressing..." for a 
> few seconds, and then comes a reset.
> 
> This question has come up before...is there some sort of max size. that 
> I am exceeding?  With 8 GB of physical memory and 64-bit arch. 
> (AMD-II), certainly seems that there should be enough memory, no?
> 
> Thanks...

What bootloader are you using?  There are some bootloaders which don't
allocate the initramfs in a very good spot.

	-hpa
