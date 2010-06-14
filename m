Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0FNQIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:08:35 -0400
Received: from daytona.panasas.com ([67.152.220.89]:50548 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752666Ab0FNQIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:08:34 -0400
Message-ID: <4C1653FF.3080108@panasas.com>
Date: Mon, 14 Jun 2010 19:08:31 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Borislav Petkov <bp@alien8.de>,
       =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [uml-devel] [PATCH resend] um, hweight: Fix UML boot crash
References: <4C0F4B00.4090307@panasas.com>	<4C0F4C40.5020207@panasas.com> <AANLkTinwQmWP-rFu9e-ns5twsZwZjuSLi5vcll55ZZhx@mail.gmail.com> <4C0FDD8C.2020704@zytor.com>
In-Reply-To: <4C0FDD8C.2020704@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2010 16:08:33.0297 (UTC) FILETIME=[D6666810:01CB0BDB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 09:29 PM, H. Peter Anvin wrote:
> On 06/09/2010 01:46 AM, Geert Uytterhoeven wrote:
>>
>> Peter, are you happy with this?
>> Although we still don't know why UML cannot grok it, it does fix a
>> regression in post-2.6.34.
>>
> 
> Yes, I'll push it.
> 
> 	-hpa

Peter hi.

Why have we missed that patch from -rc3. This is so *not fun* to keep
out-of-tree patches. Specially when working with lots of other people's
trees.

Please push it ASAP
Boaz
