Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab0CTUQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 16:16:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41714 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab0CTUQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 16:16:07 -0400
Message-ID: <4BA52D01.1070506@zytor.com>
Date: Sat, 20 Mar 2010 13:16:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Nigel Kukard <nkukard@lbsd.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel 2.6.33-rc4 OOPS's with large initramfs
References: <4B519F14.7020104@lbsd.net> <4B5CD711.7050204@zytor.com> <4BA51022.4010309@lbsd.net> <4BA51A48.6010509@zytor.com> <4BA52B6F.2060402@lbsd.net>
In-Reply-To: <4BA52B6F.2060402@lbsd.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2010 01:09 PM, Nigel Kukard wrote:
>>>     
>> How much RAM are you giving your VM?  The default for Qemu is 128 MB,
>> and if you have a 110 MB initramfs it's hardly surprising that you get
>> an out of memory error.
> 
> The kernel now boots where it booted for my 64bit box.
> 
> The main problem though is the instant reboots for bzip2 and lzma
> compressed initramfs images. The change for printf to /usr/bin/printf
> both render the sane end result when run with the same commandline being
> run in the makefile, so this isn't the issue.
> 

Oh, you have *that* problem.

What printf is being used?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

