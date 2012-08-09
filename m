Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab2HITmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:42:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51438 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759376Ab2HITmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:42:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] timekeeping: Fix build when generic clockevents are enabled
Date: Thu, 9 Aug 2012 21:48:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1344513580-9571-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1344513580-9571-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208092148.18364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 09, 2012, Mark Brown wrote:
> Commit a2c204 (timekeeping: Add suspend and resume of clock event devices)
> added suspend and resume operations for clockevents but did not provide
> stubs for these functions, breaking the build when clockevents are not
> being built. Add the stubs.

By the way, if you use commit IDs in changelogs like this, please say that
they are linux-next commits if that's the case.  Otherwise it may look like
you're fixing a mainline issue, which is not the case here.

This particular commit is not present in any pulished tree except for
linux-next (yet), which is deliberate, because it's going to be rebased in
the future and its hash will change.

Thanks,
Rafael
