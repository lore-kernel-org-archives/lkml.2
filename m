Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab0ENVHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:07:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58192 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759443Ab0ENVHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:07:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
Date: Fri, 14 May 2010 23:08:48 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@fifo99.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Matthew Garrett <mjg@redhat.com>
References: <1273810273-3039-1-git-send-email-arve@android.com>
In-Reply-To: <1273810273-3039-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005142308.48386.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 May 2010, Arve Hjønnevåg wrote:
> This patch series adds a suspend-block api that provides the same
> functionality as the android wakelock api. This version has some
> changes from, or requested by, Rafael. The most notable changes are:
> - DEFINE_SUSPEND_BLOCKER and suspend_blocker_register have been added
>   for statically allocated suspend blockers. 
> - suspend_blocker_destroy is now called suspend_blocker_unregister
> - The user space mandatory _INIT ioctl has been replaced with an
>   optional _SET_NAME ioctl.
> 
> I kept the ack and reviewed by tags on two of the patches even though
> there were a few cosmetic changes.

Thanks for the patches, I think they are in a pretty good shape now.

That said, I'd like the changelogs to be a bit more descriptive, at least for
patch [1/8].  I think it should explain (in a few words) what the purpose of
the feature is and what problems it solves that generally a combination of
runtime PM and cpuidle is not suitable for in your opinion.  IOW, why you
think we need that feature.

The changelog of patch [2/8] appears to be outdated, that needs to be fixed.
Also, it would be nice to explain in the changelog what the interface is needed
for (in terms of the problems that it helps to handle).

Rafael
