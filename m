Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0ICJat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:30:49 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:47666 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755849Ab0ICJaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:30:46 -0400
Message-ID: <4C80BFCB.20106@snapgear.com>
Date: Fri, 3 Sep 2010 19:28:43 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Fix M68K irqflags
References: <4C809B63.2040802@snapgear.com> <4C804F3A.8020001@snapgear.com> <19747.1283422807@redhat.com> <20100902102203.19806.39028.stgit@warthog.procyon.org.uk> <7077.1283496259@redhat.com> <13782.1283501148@redhat.com>
In-Reply-To: <13782.1283501148@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2010 09:28:55.0447 (UTC) FILETIME=[6DF29A70:01CB4B4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/10 18:05, David Howells wrote:
> Greg Ungerer<gerg@snapgear.com>  wrote:
>
>>> Unfortunately, I don't have a binutils that can handle the funny Coldfire
>>> instructions.  Can you point me at a Coldfire toolchain?
>>
>> This is what I currently use:
>>
>> http://www.uclinux.org/pub/uClinux/m68k-elf-tools/tools-20080626/m68k-uclinux-tools-20080626.sh
>>
>> Its just a binutils-2.18 and gcc-4.2.4 configured for m68k-uclinux
>> target.
>
> With this toolchain and the m68knommu defconfig, the asm errors are now gone,
> but I see the following link error:
>
> /usr/local/bin/m68k-uclinux-ld.real: error: no memory region specified for loadable section `.data..shared_aligned'

You need to apply this patch to fix this (sent to Linus,
but not in head yet)

http://marc.info/?l=linux-kernel&m=128347657132425&w=2

Regards
Greg

