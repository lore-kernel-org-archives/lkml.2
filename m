Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab0FRXV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 19:21:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54398 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab0FRXV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 19:21:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH] DRM / radeon / PM: Do not evict VRAM during freeze phase of hibernation
Date: Sat, 19 Jun 2010 01:19:33 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       "dri-devel" <dri-devel@lists.freedesktop.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <201006182221.57333.rjw@sisk.pl> <AANLkTim0QKSs9nrBnl847XhdM9YiKBEyNATPCscgcT5M@mail.gmail.com>
In-Reply-To: <AANLkTim0QKSs9nrBnl847XhdM9YiKBEyNATPCscgcT5M@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006190119.33759.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 18, 2010, Rafał Miłecki wrote:
> 2010/6/18 Rafael J. Wysocki <rjw@sisk.pl>:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Thanks for you recent involvement in radeon driver!

Well, I'm just trying to address the issues I see on my test boxes.

> I can see you used way shorter commit title this time ;) Just as a minor
> note, maybe you could follow prefix-style we used to see around? Like simple
> "drm/radeon/pm"? Or eventually something different instead of "pm" to
> match difference between s/r and pm as engine/memory/voltage ops.

Sure, I can use whatever is suitable to you guys.

Thanks,
Rafael
