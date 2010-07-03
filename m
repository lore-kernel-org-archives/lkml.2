Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0GCI0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:26:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36602 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab0GCI0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:26:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vhu1zJblr4yDqVruU32GGlr26q95wpn+RcPTCrsFs2lxbz3cBD0awjG99p4SxRGpqQ
         qjuQAU9G1gPrzlf7ajJDqPBVzVgjeSFV/t1l+Z/8oR7J3D93dvTRhO0eYT/Yz7C1Va10
         hT/uPevMFQS+aw3M8sgnYBEKzUHbrgkc++s1w=
MIME-Version: 1.0
In-Reply-To: <20100701224235.GA29504@core.coreip.homeip.net>
References: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
	<20100701162454.GD4152@core.coreip.homeip.net>
	<AANLkTikx8AxRdPoSbsym9rUiA11BbufqImcD2sg4f8Ds@mail.gmail.com>
	<AANLkTikmcaQSNNy6ZHMvEwBJVkWdyQ5KALR6832hUkjz@mail.gmail.com>
	<20100701224235.GA29504@core.coreip.homeip.net>
Date: Sat, 3 Jul 2010 10:26:13 +0200
Message-ID: <AANLkTilPJ6Vod4zU4gfOC3id-Cxy_Ho4I5lxMh5fLaCV@mail.gmail.com>
Subject: Re: i8042 no mouse on resume. (i8042: failed to resume active 
	multiplexor, mouse won't work.)
From: Jerome Lacoste <jerome.lacoste@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 12:42 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Jul 02, 2010 at 12:28:17AM +0200, Jerome Lacoste wrote:
>> On Thu, Jul 1, 2010 at 11:19 PM, Jerome Lacoste
>> <jerome.lacoste@gmail.com> wrote:
>> > On Thu, Jul 1, 2010 at 6:24 PM, Dmitry Torokhov
>> > <dmitry.torokhov@gmail.com> wrote:
>> >> Hi Jerome,
>> >>
>> > [...]
>> >>> * the hardware is a Lenovo 3000 N100
>> >>
>> >> We already trying to disable MUX mode on Lenovo 3000 N100, see
>> >> drivers/input/serio/i8042-x86ia64io.h:
>> >>
[...]
>> > System Information
>> >        Manufacturer: LENOVO
>> >        Product Name: 0768BKG
>> >        Version: 3000 N100
>> >
>> > according to dmidecode
>>
>> Note: I will try the i8042.nomux option, but can't reboot until tomorrow.
>
> Could you please also try i8042.reset instead of i8042.nomux?

the i8042.reset works so far after 5 resumes.

Tested with: Linux expresso2 2.6.32-23-generic #37-Ubuntu SMP Fri Jun
11 07:54:58 UTC 2010 i686 GNU/Linux

Should I test something else ?

Jerome
