Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927Ab0J0P7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:59:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38927 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab0J0P7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LBtmP6IUtP9jLw1CIaOLGhiXBMs4HeF84b5v28roTAJzvE/Pa1yzFJrChCM/La/kbq
         3kPDz6Y1G3H09nd72w3LnrphZYzDSNUpYwjM8HnwLRFAVTfUFkWVD4zi1DuJWyHbx2gB
         8xUgy89xnJxQYKrfjzgiFuk63K7VZwjC4ErTI=
MIME-Version: 1.0
In-Reply-To: <1288190315.18238.128.camel@gandalf.stny.rr.com>
References: <cover.1288176026.git.wuzhangjin@gmail.com>
	<910dc2d5ae1ed042df4f96815fe4a433078d1c2a.1288176026.git.wuzhangjin@gmail.com>
	<1288186366.18238.125.camel@gandalf.stny.rr.com>
	<AANLkTinsfveuYdo4YJGHqasPgG=+ftL-8sbC5_aYAytt@mail.gmail.com>
	<1288190315.18238.128.camel@gandalf.stny.rr.com>
Date: Wed, 27 Oct 2010 23:59:28 +0800
Message-ID: <AANLkTinW8b6y4zcGMryYK3Q=uPOvRJyZVidj-Rf=LHzj@mail.gmail.com>
Subject: Re: [PATCH 1/3] ftrace/MIPS: Add MIPS64 support for C version of recordmcount
From: wu zhangjin <wuzhangjin@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, John Reiser <jreiser@bitwagon.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 10:38 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2010-10-27 at 22:09 +0800, wu zhangjin wrote:
>> On Wed, Oct 27, 2010 at 9:32 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Wed, 2010-10-27 at 18:59 +0800, Wu Zhangjin wrote:
>> >> From: Wu Zhangjin <wuzhangjin@gmail.com>
>> >
>> > The From above states that you wrote this. Did you modify what John and
>> > Maciej did? If so, please state clearly what each author has done, and
>> > how you modified it. If you did not write this, please change the From
>> > to the correct author.
>> >
>> > If you did modify it, then state something like this in the change log.
>> >
>> > Original version written by John Reiser <jreiser@BitWagon.com>
>> >
>> > Usage of "union mips_r_info" and the functions MIPS64_r_sym() and
>> > MIPS64_r_info() written by Maciej W. Rozycki <macro@linux-mips.org>
>> >
>>
>> yeah, that is true above.
>>
>> > Then state the changes you made.
>>
>> I didn't change it, just added the comments in the patch log and tested it.
>>
>> Should I resend the patch with the change log information about John and Maciej?
>>
>
> I can make the changes.
>

ok, thanks.

> Then the patch is originally John's, right?
>

Yes, John write it.

> I'll make him the author, with the comment about Maciej, and keep you as
> the Tested-by.

ok, Macjej has simplified the r_info of MIPS there, so perhaps we need
to add SoB for him and he told me to add that line.

For me, Tested-by: is ok.

Regards,
Wu Zhangjin
