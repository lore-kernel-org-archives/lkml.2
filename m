Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311Ab0KPGXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 01:23:35 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21873 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab0KPGXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 01:23:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jwJH6ZAUtj3/I9zc02Gj5Oj1sdYIvWOcs6KBDpy1G33ane/zxMH5l8Ksp72HU8wNYs
         gVO39kkULpPFZs9F4lHA==
MIME-Version: 1.0
In-Reply-To: <jwvoc9qh4yp.fsf-monnier+gmane.comp.embedded.openwrt.devel@gnu.org>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
	<AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
	<20101106181202.GA6927@kroah.com>
	<39580686-A899-4689-BAAD-AF5546B34E49@mac.com>
	<AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
	<20101107155757.GA13736@kroah.com>
	<AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com>
	<jwvoc9qh4yp.fsf-monnier+gmane.comp.embedded.openwrt.devel@gnu.org>
Date: Mon, 15 Nov 2010 22:23:29 -0800
Message-ID: <AANLkTimFkdArTMscJOiPf-YwKaEKsq59XM_u4Twes4PP@mail.gmail.com>
Subject: Re: Forked android kernel development from linux kernel mainline
From: Brian Swetland <swetland@google.com>
To: Stefan Monnier <monnier@iro.umontreal.ca>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 9:34 AM, Stefan Monnier
<monnier@iro.umontreal.ca> wrote:
>> Just a small comment to say that Android is not the only one (but
>> certainly the most visible, and thus easiest to bash on) not making
>> effort to get their stuff in mainline.
>
> It's not only that.  But Android in general is also a very poor citizen
> w.r.t Free Software since it tends to be distributed in closed form for
> devices that only work if you add proprietary code, and it supports
> DRM-style nightmares.

We release the userspace and kernel work we do under Apache2/BSD/MIT
and GPLv2 respectively.

We have always insisted on only GPLv2 code for kernel drivers, and
have never supported binary loadable kernel drivers.

We typically have to deal with some proprietary userspace libraries
(opengl es 2 libraries are a typical example), though we've been
working to reduce the number from release to release.  This is an
artifact of the current SoC offerings more than any policy we have --
we much prefer entirely open solutions and actively pursue them
whenever possible.

I'm not sure what DRM-style nightmares we're talking about -- last I
looked, the stock Android platform doesn't have any DRM support of any
sort built-in.

We certainly can't demand that every OEM work this way, but so it goes.

> It's not as dangerous to Free Software as the iphone, tho.

Whew!

>> OpenWRT people are also maintaining their fork of the kernel, without
>> even using git, and not contributing much to mainline (I'm certainly
>> mistaken on that last comment).
>
> I can assure you that the contributions are as frequent, important, and
> significant as the OpenWRT can muster: they have very limited resources,
> which is the main limitation.  But also because of those limited
> resources, it's in their best interest to get things upstream.
>
> Android is different since the company behind it made a conscious
> decision to fork even though they have/had the resources necessary to
> push their changes upstream.

I view it more as we made a decision to ship (and enable others to
ship) successful products as priority one, while still making the
source available (as is required, or in some cases not required).

I am always intrigued that everyone is an expert in our resource
availability.  Apparently my team has a bunch of engineers loafing
around when they could be contributing patches upstream!  Or, maybe,
we're also a very busy bunch of people supporting multiple SoCs,
multiple hardware platforms, multiple releases, who also send code
upstream from time to time, but clearly not as much or as often as
people would like (including ourselves).

Brian
