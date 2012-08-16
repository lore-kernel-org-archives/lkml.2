Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab2HPVKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:10:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53568 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2HPVKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:10:45 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: a3at.mail@gmail.com
Date: Fri, 17 Aug 2012 01:10:44 +0400
X-Google-Sender-Auth: CX2snKnf_9ml78efsBDBWB6rSJ0
Message-ID: <CAAW1UO-nXDDAB9fC6fDJ6+XVnidXOARdVhq=_XJgngmnMj7gPQ@mail.gmail.com>
Subject: high load average in linux-3.6
From: Azat Khuzhin <dohardgopro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

After updating to linux-v3.6-rc1-315-g3c31a6e I noticed that load avg
is too high for "current" CPU usage & IO activity

Just after starting, I see next things:
1) I'v kill all processes that I "can"
iostat_min_tasks - http://pastebin.com/T59xKEy4
ps_min_tasks - http://pastebin.com/b7zVy6up
w_min_tasks - http://pastebin.com/UFFsncSn

2) After I started some processes/services (kde,nginx,mysql ...)
iostat_with_graph - http://pastebin.com/bejGneGv
ps_with_graph - http://pastebin.com/Nt9g0ynW
w_with_graph - http://pastebin.com/pYuUbyVY
( graph - with DE )

When I 3.3.0 I did not notice such situation.

I'v trying to set kernel cmd line to "i915.i915_enable_rc6=1
i915.i915_enable_fbc=1 i915.lvds_downclock=1 drm.vblankoffdelay=1"
like here https://bugs.archlinux.org/task/29850
But this doesn't helps.

--
Azat Khuzhin
