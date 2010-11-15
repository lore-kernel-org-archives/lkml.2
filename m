Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab0KORei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:34:38 -0500
Received: from lo.gmane.org ([80.91.229.12]:58122 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933013Ab0KOReh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:34:37 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Re: Forked android kernel development from linux kernel mainline
Date: Mon, 15 Nov 2010 12:34:15 -0500
Message-ID: <jwvoc9qh4yp.fsf-monnier+gmane.comp.embedded.openwrt.devel@gnu.org>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
	<AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
	<20101106181202.GA6927@kroah.com>
	<39580686-A899-4689-BAAD-AF5546B34E49@mac.com>
	<AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
	<20101107155757.GA13736@kroah.com>
	<AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 69-165-142-250.dsl.teksavvy.com
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
Cancel-Lock: sha1:c5p4AOSxoJoJaeVo9/1LVPCAYe4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just a small comment to say that Android is not the only one (but
> certainly the most visible, and thus easiest to bash on) not making
> effort to get their stuff in mainline.

It's not only that.  But Android in general is also a very poor citizen
w.r.t Free Software since it tends to be distributed in closed form for
devices that only work if you add proprietary code, and it supports
DRM-style nightmares.
It's not as dangerous to Free Software as the iphone, tho.

> OpenWRT people are also maintaining their fork of the kernel, without
> even using git, and not contributing much to mainline (I'm certainly
> mistaken on that last comment).

I can assure you that the contributions are as frequent, important, and
significant as the OpenWRT can muster: they have very limited resources,
which is the main limitation.  But also because of those limited
resources, it's in their best interest to get things upstream.

Android is different since the company behind it made a conscious
decision to fork even though they have/had the resources necessary to
push their changes upstream.


        Stefan

