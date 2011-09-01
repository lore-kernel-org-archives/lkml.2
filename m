Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1IAKhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 06:37:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64297 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab1IAKhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 06:37:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAEDdjHfu71X04JR2Yx8N495bDoJRudch3xbzNAEmUpVxYS+Oww@mail.gmail.com>
References: <CAEDdjHfu71X04JR2Yx8N495bDoJRudch3xbzNAEmUpVxYS+Oww@mail.gmail.com>
Date: Thu, 1 Sep 2011 11:37:41 +0100
Message-ID: <CAEDdjHfa-+DwCEpGYnE++FmxOigWWnaE4grGwW74T2LUYpgsQw@mail.gmail.com>
Subject: Fwd: Thinkpad hotkeys and USB audio not working after resume in 3.0.x
From: Pedro Ribeiro <pedrib@gmail.com>
To: Kernel development list <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm hitting a bug with my thinkpad T400. After resuming from
Hibernate, the thinkpad hotkeys and my USB audio card do not work at
all.
Suspending to RAM and resuming seem to solve the problem, but after
another hibernation it comes back again.

This only happens with TuxOnIce but not with the vanilla kernel.

Rafael, can you please point out from the top of your head if there
was any change that could have caused this?

Thanks in advance.

Kind Regards,
