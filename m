Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab2BPPdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:33:41 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:43231 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2BPPdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:33:40 -0500
Message-ID: <4F3D21C8.8020301@free-electrons.com>
Date: Thu, 16 Feb 2012 16:33:28 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Olexiy Avramchenko <aolexiy@gmail.com>
CC: linux-arm-kernel@lists.arm.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: add support for xz kernel decompression
References: <1329404057-26346-1-git-send-email-michael.opdenacker@free-electrons.com> <1329404057-26346-3-git-send-email-michael.opdenacker@free-electrons.com> <CAGvbF3KGYkye8z_gcpq20W+j+TugwkX0xjjHcbNf5jwibi_cRQ@mail.gmail.com>
In-Reply-To: <CAGvbF3KGYkye8z_gcpq20W+j+TugwkX0xjjHcbNf5jwibi_cRQ@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olexiy,

Thanks for the code review!

On 02/16/2012 04:13 PM, Olexiy Avramchenko wrote:
> Hi, Michael
>
> Spotted minor typo (I guess):
>
>> -extra-y       += piggy.gzip piggy.lzo piggy.lzma lib1funcs.S $(libfdt) $(libfdt_hdrs)
>> +extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xz lib1funcs.S $(libfdt) $(libfdt_hdrs)
> Shouldn't it be piggy.xzkern here? I'd also stick with *.xz as on x86,
> but that's probably not so important.
You're right, that should be piggy.xzkern indeed, as this is the file
that is generated. Unless we make more changes, we have to stick to this
filename, because 'xzkern' is also the command that's called to compress
the kernel image.

I will post an update soon.

Thanks again,

Michael.

-- 
Michael Opdenacker, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
+33 484 253 396

