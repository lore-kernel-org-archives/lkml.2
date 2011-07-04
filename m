Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab1GDP5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:57:03 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42992 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102Ab1GDP46 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:56:58 -0400
MIME-Version: 1.0
In-Reply-To: <87hb72skik.fsf@rustcorp.com.au>
References: <1308434431.1050.5.camel@mop> <8739j59zib.fsf@rustcorp.com.au>
 <BANLkTink8YTe=-Tr5Ax3epiFoFCfzcex7w@mail.gmail.com> <87boxshrwe.fsf@rustcorp.com.au>
 <BANLkTinL4r3RfNuA5x6=UK4DCSSJNeZw7w@mail.gmail.com> <87r56m8w2b.fsf@rustcorp.com.au>
 <BANLkTimNpDdp+JBXt0wUjuc0awypJSvXRg@mail.gmail.com> <87fwn18k9h.fsf@rustcorp.com.au>
 <BANLkTi=v-axftYKJCJ33+9UnfF9NJDAykQ@mail.gmail.com> <BANLkTimmTpcPefmWz=H7+4R6-7o4dZ+hnQ@mail.gmail.com>
 <87hb72skik.fsf@rustcorp.com.au>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 4 Jul 2011 17:56:37 +0200
Message-ID: <CAPXgP117WLtEX7ecrr9rs7HP0ZYkh25JmKbRj7YRuvGVw359PA@mail.gmail.com>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 4, 2011 at 07:05, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Fri, 1 Jul 2011 05:07:41 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> On Thu, Jun 23, 2011 at 13:24, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> > On Thu, Jun 23, 2011 at 02:27, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> >> On Wed, 22 Jun 2011 12:17:49 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> >>> On Wed, Jun 22, 2011 at 04:00, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> >> I'd prefer that patch first, I think: it's a sensible cleanup.
>> >
>> > You want the patch split up in two? You want to remove the mod
>> > parameter somehow?
>>
>> Can we get these 20 lines of code sorted out please? :)
>
> An odd question, since I was waiting for you to do exactly that!

Oh, I was just waiting for your answer to the earlier question 6 lines
above here. :)

> Rather than go around again, I have:
> 1) Split the patch into one which changes the attr functions, and one
>   which adds the uevent file.
> 2) Fixed the title of the (second) patch to "module: add
>   /sys/module/<name>/uevent files"
> 3) Fixed up the three checkpatch.pl errors (sure, 2 were just code
>   moves, but we're slowly neatening things).
>
> Here they are below, back-to-back.

Great. Thanks a lot for doing this.

Kay
