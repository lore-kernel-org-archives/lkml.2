Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0FETxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:53:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37580 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab0FETxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wIHLHrTquvog9HBMVQcT6KQVj0SU7F4cc9+6rG+aX1I3DceeAWLU5pmaSqdLjJCL7p
         O4bbUgOXtWnwX2plWzHLG+rlQ43hVwBJ5vY+Hlxn5LBTNiqlMbirJNr7k+yp8QLwm6Ze
         fNC/1JUO45kQQdA6cXFJQIyZP8XYRKnlFKGoQ=
MIME-Version: 1.0
In-Reply-To: <201006052104.05324.rjw@sisk.pl>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<20100531224732.2073828d@schatten.dmk.lab>
	<AANLkTinPUNer7XhAqS4VSWhOxqjEjaHtr76EK5tzYYjJ@mail.gmail.com>
	<201006052104.05324.rjw@sisk.pl>
Date: Sat, 5 Jun 2010 22:53:50 +0300
Message-ID: <AANLkTin2DjZjx7VNsWg7450sAUuQTIrUPyC2TA2MNPAP@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 5, 2010 at 10:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday 05 June 2010, Felipe Contreras wrote:
>> On Mon, May 31, 2010 at 11:47 PM, Florian Mickler <florian@mickler.org> wrote:
>> > On Mon, 31 May 2010 22:12:19 +0200
>> > Florian Mickler <florian@mickler.org> wrote:
>> >> If I have a simple shell script then I don't wanna jump through
>> >> hoops just to please your fragile kernel.
>> >
>> > Also why should that code on one device kill my uptime and on the
>> > other machine (my wall-plugged desktop) work just well? That doesn't
>> > sound right.
>>
>> Sounds perfectly right to me; one code runs perfectly fine on one
>> machine, and on the other doesn't even compile. Well, sure, it wasn't
>> written with that use-case in mind.
>>
>> > Clearly opportunistic suspend is a workaround for battery-driven devices
>> > and no general solution. But it is not specific to android. At least
>> > not inherently. It could be useful for any embedded or mobile device
>> > where you can clearly distinguish important functions from convenience
>> > functions.
>>
>> Yes, it could, but why go for the hacky solution when we know how to
>> achieve the ideal one?
>>
>> > I really can't understand the whole _fundamental_ opposition to this
>> > design choice.
>>
>> Nobody is using it, except Android. Nobody will use it, except Android.
>
> That's like saying "Android is not a legitimate user of the kernel".  Is that
> you wanted to say?

Read the context: opportunistic suspend, which is considered a
workaround, which requires new user-space API for suspend blockers,
might be remotely considered for inclusion *if* it indeed solves a
problem for battery-driven devices, which other parties also
experience and could benefit from this solution.

The answer: no, it doesn't: only Android user-space will benefit from it.

>> I have seen recent proposals that don't require changing the whole
>> user-space. That might actually be used by other players.
>
> Sure, an approach benefitting more platforms than just Android would be better,
> but saying that the kernel shouldn't address the Android's specific needs as a
> rule if no one else has those needs too is quite too far reaching to me.

There are no Android specific needs, why should certain user-space
ecosystem need certain API that somehow *nobody* else does? I think in
this huge thread it has become obvious that people are reluctant to
this idea... whatever problem Android user-space presents (I don't
think there's any), it can be solved for "he rest of the world" too,
and such generic solution is worth exploring.

-- 
Felipe Contreras
