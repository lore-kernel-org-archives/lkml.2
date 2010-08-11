Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab0HKWMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 18:12:50 -0400
Received: from smtp-out.google.com ([74.125.121.35]:26919 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab0HKWMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 18:12:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=qYs9lQb3tofxHj5OVXNMMbx8xV4afJqoUxKfE2jED4wxJCWV+cnPskZWJtrmgztrs
	E35Ch9IaplpNRFLxHskaQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTimAKwDPYZeCj_UEyXf-6DxLg8=Zi-=tFKzzgvQi@mail.gmail.com>
References: <20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
	<AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<AANLkTinNc1SWmz8pE_4k6vThxQCJfCR_UqV6OM=OsJOf@mail.gmail.com>
	<20100811193106.GB24435@thunk.org>
	<AANLkTinBrp1iHWAi=vk_eaEHMs+Xcub6rg8PgT_LK2c9@mail.gmail.com>
	<AANLkTinOb5PsrLbMzbYVqqx=6n-yPNRCYgOf4fM5KdXJ@mail.gmail.com>
	<AANLkTimAKwDPYZeCj_UEyXf-6DxLg8=Zi-=tFKzzgvQi@mail.gmail.com>
Date: Wed, 11 Aug 2010 15:12:44 -0700
Message-ID: <AANLkTimwdJgAUHNgUDwagDhBd2MtEoSbt7rFa2dPkm2c@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Brian Swetland <swetland@google.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 3:03 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
>> Once "the right solution" exists and solves our problems, we'll
>> certainly look into switching over to it.  I've yet to see a proposal
>> in all this arguing that appears to me to be an improvement over what
>> we have today with suspend blockers.  I find the "don't do what you're
>> doing because someday, somebody will do it better" to be an
>> uncompelling argument.
>
> That was not an argument, it was an opinion. If you want an argument
> go back to read this one:
> http://article.gmane.org/gmane.linux.kernel/1021834
>
>> Given your opinion that Android lacks multitasking (what? really?)
>
> This is what I'm talking about when I say multi-tasking, Android
> certainly doesn't have anything remotely like that:
> http://www.youtube.com/watch?v=7emvUBpEkbU

Home + pick app -> switch to the app in whatever state it was in.

Home (longpress) -> recent app list + pick app from popup -> switch to
recent app in whatever state it was in.

pull down alert windowshade + pick app from alerts list -> switch to that app

I routinely flip back and forth between email / browser / IM / musicplayer / etc

I have no problem with you perhaps liking the visuals of the N900
better, but to say Android lacks multitasking (as you explain it
below) is incorrect:

> By multi-tasking I mean me (the user) being able to perform multiple
> tasks at the same time.

> For example: writing an email, while browsing the web, while having IM
> conversations. Obviously not exactly at the same time; start writing
> an email, go browse for some url, copy, answer a pending IM message,
> go back to the mail, paste.

As far as implementing app switching with a deck of cards metaphor,
I've seen that done by some OEMs with Android, though it's not the
default system UI.

Brian
