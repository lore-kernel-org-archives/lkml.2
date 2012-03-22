Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2CVEgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 00:36:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab2CVEgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 00:36:41 -0400
Message-ID: <4F6AAC57.3090507@gmail.com>
Date: Wed, 21 Mar 2012 22:36:39 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Chris Holland <bandidoirlandes@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: IDE DVD and CD drive seem to not work with Linux desktop 3.3.0-030300-generic
References: <CAMfrEMaV03CEZ-h7k9K78c8+T+AC47=QypnyhQG7LFgrQQ32tA@mail.gmail.com>
In-Reply-To: <CAMfrEMaV03CEZ-h7k9K78c8+T+AC47=QypnyhQG7LFgrQQ32tA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 10:29 PM, Chris Holland wrote:
> Please cc me at: bandidoirlandes@gmail.com
>
> My optical drives are not working with 3.3 but they worked fine with 3.3rc7
> These are the kernels from http://kernel.ubuntu.com/~kernel-ppa/mainline/
> Ubuntu 11.10
>
> Not working
> Linux desktop 3.3.0-030300-generic #201203182135 SMP Mon Mar 19
> 01:36:20 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
> cat /var/log/dmesg | egrep '(CD|DVD)'
> [    0.000000]   CD000-EFFFF uncachable
>
> Working
> Linux desktop 3.3.0-030300rc7-generic #201203101735 SMP Sat Mar 10
> 22:36:28 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
> cat /var/log/dmesg | egrep '(CD|DVD)'
> [    0.000000]   CD000-EFFFF uncachable
> [    0.092676] ACPI Warning: Incorrect checksum in table [TAMG] -
> 0xCD, should be 0xCC (20120111/tbutils-321)
> [    6.324511] ata9.01: ATAPI: LITE-ON DVDRW SHW-160P6S, PS0A, max UDMA/66
> [    6.397218] scsi 8:0:0:0: CD-ROM            LITE-ON  LTR-48246S
>    SS0B PQ: 0 ANSI: 5
> [    6.419770] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    6.419898] sr 8:0:0:0: Attached scsi CD-ROM sr0
> [    6.427088] scsi 8:0:1:0: CD-ROM            LITE-ON  DVDRW
> SHW-160P6S PS0A PQ: 0 ANSI: 5
> [    6.429600] sr 8:0:1:0: Attached scsi CD-ROM sr1
>
> I tried to do a git bisect but I dont know what I am doing. Might just
> be my computer acting up.

Can you post the full dmesg output from the non-working kernel?
