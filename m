Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2DIMgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:36:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63897 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab2DIMgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <4F829818.6040600@broadcom.com>
References: <1333903588-32608-1-git-send-email-mcgrof@frijolero.org> <4F829818.6040600@broadcom.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 9 Apr 2012 05:36:21 -0700
X-Google-Sender-Auth: NL_sH-nwazMdFAZbGlc9X4U3HYk
Message-ID: <CAB=NE6VBGg7-RxcmLUd8j3spTid6J3N3hsUPsuTt3aDx_0mmEg@mail.gmail.com>
Subject: Re: [PATCH v2] module: Clarify usage of MODULE_LICENSE()
To: Arend van Spriel <arend@broadcom.com>
Cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tso Ted <tytso@mit.edu>, Keith Packard <keithp@keithp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
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

On Mon, Apr 9, 2012 at 1:04 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 04/08/2012 06:46 PM, Luis R. Rodriguez wrote:
>>
>>  include/linux/module.h |   17 +++++++++++++----
>>  1 file changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index fbcafe2..8d36d86 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> - * This exists for several reasons
>> + * The MODULE_LICENSE() exists for several reasons:
>> + * 0.   So EXPORT_SYMBOL_GPL() allows the module to use its symbols
>
>
> It seems there is some tab/space mixup here.

Ah yes, I'll send a v3.

> Also not sure if the above statement is clear or correct.
> Correct me if I am wrong, but I thought it
> put a requirement on other modules to be able to use its symbols.

Never heard of this but boy, wouldn't that be nice.

  Luis
