Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab1ESPIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:08:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1ESPIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:08:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Date: Thu, 19 May 2011 17:08:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
References: <201105181047.17309.arnd@arndb.de> <201105191550.20129.arnd@arndb.de> <BANLkTikKhZu_H_QT+Uds22sepk1OnEeDNA@mail.gmail.com>
In-Reply-To: <BANLkTikKhZu_H_QT+Uds22sepk1OnEeDNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191708.27464.arnd@arndb.de>
X-Provags-ID: V02:K0:AFgRerG6sl8MTh/owsl8ysWNIieONOtsUl7w5Sa602Y
 HAqmHtC271tjjOSE3iNnuNXW6XfLXDQxJ9nzSNobk4mk0JGBvO
 dlpO/BZhQAE5ZpJ3O/ZOrxSfrhU8kNxd3cxKIZ97bB2fEgpAyK
 A8mOXiRnBkU1fxHqSC2UE4Cjlmgx0z0Dj2Rf/cI6vDJhP+fHHi
 mn5/Sk1swyl51P8fQSsEg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 May 2011, Barry Song wrote:
> >
> > Do you have a diffstat or a git tree with your work available?
> 
> not yet by now. it should be coming in the middle of next month. we
> have workable codes but need a lot of refinations before sending
> patches for review. it is more like a new begin from scratch, so
> arm/arch changes should be things we can catch.

I'd like to make sure that you are not doing duplicate work by
going in a wrong direction with this, so I think it would be best
to post as early as possible, ideally with a list of things that
you already know you need to change, so people don't need to comment
on them.

If you can just post a diffstat of the stuff you currently have,
we also get an impression of the amount of code that you are
talking about.

	Arnd
