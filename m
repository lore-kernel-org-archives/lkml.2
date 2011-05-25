Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1EYUel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:34:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63987 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab1EYUek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:34:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: add /proc/tile, /proc/sys/tile, and a sysfs cpu attribute
Date: Wed, 25 May 2011 22:34:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com> <201105252220.23948.arnd@arndb.de> <4DDD6729.7070201@tilera.com>
In-Reply-To: <4DDD6729.7070201@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105252234.30808.arnd@arndb.de>
X-Provags-ID: V02:K0:51GnznOQvZdg2tM2cjFBKfFzCJavN6qoe6xKe1BtGYz
 Giwwx0gjF+/9YAcEaTkLwWnlJ5kxLfAJigDckvdi/rrfhJpoL+
 kn998muIKKtEWolBGXSCoOXToW3vSs93uHNxXwqDyClryrDJdj
 ism8mK7DYeESWsgN2HVjHbOnWwKtBYea5GD3viLW6fNtkkryPk
 WgvjN6rfpx2Vk+n+ivj5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 May 2011 22:31:37 Chris Metcalf wrote:
> On 5/25/2011 4:20 PM, Arnd Bergmann wrote:
> > On Wednesday 25 May 2011 21:18:05 Chris Metcalf wrote:
> >> The contents of the hardwall ID file are then just a cpulist of the cpus
> >> covered by the hardwall, rather than introducing a new convention (as
> >> quoted above, e.g. "2x2 1,1").  Individual tasks that are in the hardwall
> >> can be found by reading the "hardwall" files, and we can learn where they
> >> are bound in the hardwall by reading the "stat" file as is normal for
> >> learning process affinity.
> > Be careful with listing PID values in the hardwall files, as the PIDs
> > may not be unique or visible if you combine this with PID name spaces.
> > I guess the right solution would be to only list the tasks that are
> > present in the name space of the thread reading the file.
> 
> Sorry not to be clearer -- I am no longer listing any PID values in the
> hardwall files, for that exact reason.  You have to look at
> /proc/*/hardwall (or /proc/*/tasks/*/hardwall) to find the files that are
> in a particular hardwall.  This pattern is not one that's normally directly
> useful, though, so I'm happy leaving it to userspace if it's desired.

Ok, thanks for the clarification.

	Arnd
