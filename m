Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab2EGWs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 18:48:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36271 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab2EGWs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 18:48:27 -0400
MIME-Version: 1.0
In-Reply-To: <87bom0hf0f.fsf@rustcorp.com.au>
References: <1333903588-32608-1-git-send-email-mcgrof@frijolero.org> <87bom0hf0f.fsf@rustcorp.com.au>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 7 May 2012 15:48:07 -0700
X-Google-Sender-Auth: 0Yv8w-SW9ofUkxh0MpanJwp1wjA
Message-ID: <CAB=NE6WLP8KWESmDi5Rfg8KPn36qwWzeEzz+0mOH5yP7i8w8eg@mail.gmail.com>
Subject: Re: [PATCH v2] module: Clarify usage of MODULE_LICENSE()
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Tso Ted <tytso@mit.edu>,
        Keith Packard <keithp@keithp.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arend Van Spriel <arend@broadcom.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 6, 2012 at 8:00 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Sun,  8 Apr 2012 09:46:28 -0700, "Luis R. Rodriguez" <mcgrof@frijolero.org> wrote:
>> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
>>
>> While the kernel is GPLv2 individual the MODULE_LICENSE() has allowed for
>> these tag to be used:
>>
>>   * Dual BSD/GPL
>>   * Dual MIT/GPL
>>   * Dual MPL/GPL
>>
>> This is done for historical reasons, namely questioning the compatibilty
>> between the GPL and some old BSD licenses. Some developers and maintainers
>> tend to use assume the macro is also used to help clarify if the module
>> source code could be shared with the BSD family, but that is not the
>> case.
>
> Incorrect.  When the author clarifies their license it *does* help.  If
> a tag and license text were to disagree, it would muddy the waters.

Heh, OK.. sure...

>> The MODULE_LICENSE() declares the module's license at run time and even for
>> the dual tags the run time license that applies is the GPL.
>
> You're probably correct, but it's very hard to care.

Its good that we seem to care to not care, given that I have avoided
addressing this for eons, but we seem to at least care enough to not
want proprietary derivatives for Linux.

>> If sharing share between Linux and permissive licensed Operating Systems such
>> as the BSDs is desired developers should review the license on the top of
>> each file being considered to be shared.
>
> Of course.  But having both is nice and clear.

Alrighty.

  Luis
