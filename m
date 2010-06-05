Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0FEREc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 13:04:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45680 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab0FEREa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 13:04:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TMCsDFIl0nIFT0H9eGUOCpwCzdtKV1h459MwbTPtJhzhc62E3QmfmxFNBPWoE+N6it
         VnsJu2Ff2d44Q2nYFBCwbLBqz/NMO8MVxPhNKSwFTmU6KuoZzlgzxnk0HNl+MwnVUEs5
         aei0LaNdb8PtAOxNrECamx/khQDnE8eCrGmow=
MIME-Version: 1.0
In-Reply-To: <20100531224732.2073828d@schatten.dmk.lab>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<1275030704.32462.11.camel@laptop>
	<AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>
	<1275120618.27810.12699.camel@twins>
	<1275149418.4503.128.camel@mulgrave.site>
	<1275156734.1645.496.camel@laptop>
	<20100531221219.212bf119@schatten.dmk.lab>
	<20100531224732.2073828d@schatten.dmk.lab>
Date: Sat, 5 Jun 2010 20:04:28 +0300
Message-ID: <AANLkTinPUNer7XhAqS4VSWhOxqjEjaHtr76EK5tzYYjJ@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 11:47 PM, Florian Mickler <florian@mickler.org> wrote:
> On Mon, 31 May 2010 22:12:19 +0200
> Florian Mickler <florian@mickler.org> wrote:
>> If I have a simple shell script then I don't wanna jump through
>> hoops just to please your fragile kernel.
>
> Also why should that code on one device kill my uptime and on the
> other machine (my wall-plugged desktop) work just well? That doesn't
> sound right.

Sounds perfectly right to me; one code runs perfectly fine on one
machine, and on the other doesn't even compile. Well, sure, it wasn't
written with that use-case in mind.

> Clearly opportunistic suspend is a workaround for battery-driven devices
> and no general solution. But it is not specific to android. At least
> not inherently. It could be useful for any embedded or mobile device
> where you can clearly distinguish important functions from convenience
> functions.

Yes, it could, but why go for the hacky solution when we know how to
achieve the ideal one?

> I really can't understand the whole _fundamental_ opposition to this
> design choice.

Nobody is using it, except Android. Nobody will use it, except Android.

I have seen recent proposals that don't require changing the whole
user-space. That might actually be used by other players.

-- 
Felipe Contreras
