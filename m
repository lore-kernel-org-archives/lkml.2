Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0FNQoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:44:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47653 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab0FNQoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:44:07 -0400
Message-ID: <4C165BCF.4030507@zytor.com>
Date: Mon, 14 Jun 2010 09:41:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Borislav Petkov <bp@alien8.de>,
       =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [uml-devel] [PATCH resend] um, hweight: Fix UML boot crash
References: <4C0F4B00.4090307@panasas.com>	<4C0F4C40.5020207@panasas.com> <AANLkTinwQmWP-rFu9e-ns5twsZwZjuSLi5vcll55ZZhx@mail.gmail.com> <4C0FDD8C.2020704@zytor.com> <4C1653FF.3080108@panasas.com>
In-Reply-To: <4C1653FF.3080108@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 09:08 AM, Boaz Harrosh wrote:
> On 06/09/2010 09:29 PM, H. Peter Anvin wrote:
>> On 06/09/2010 01:46 AM, Geert Uytterhoeven wrote:
>>>
>>> Peter, are you happy with this?
>>> Although we still don't know why UML cannot grok it, it does fix a
>>> regression in post-2.6.34.
>>>
>>
>> Yes, I'll push it.
>>
>> 	-hpa
> 
> Peter hi.
> 
> Why have we missed that patch from -rc3. This is so *not fun* to keep
> out-of-tree patches. Specially when working with lots of other people's
> trees.
> 
> Please push it ASAP
> Boaz

We made the decision of not pushing our queue for -rc3 because Linus
specifically wanted only critical fixes for -rc3.  We will push it for
-rc4 for when Linus returns.

Also, you may want to consider moderating your tone.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

