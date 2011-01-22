Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab1AVIkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 03:40:11 -0500
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:49589 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1AVIkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 03:40:10 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: Q. block: check bdev_read_only() from blkdev_get()
To: Tejun Heo <tj@kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110121132802.GD2832@htj.dyndns.org>
References: <23846.1295615979@jrobl> <20110121132802.GD2832@htj.dyndns.org>
Date: Sat, 22 Jan 2011 17:32:24 +0900
Message-ID: <5299.1295685144@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tejun Heo:
> Yeah, it should definitely reset r/w flag on each mount.  Interested
> in fixing it?

It must be faster and sure that you (or other bdev people) would fix
much more than I do.
I don't think you want me to dive into unfamiliar code.


J. R. Okajima
