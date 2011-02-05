Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1BEC2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 21:28:32 -0500
Received: from science.horizon.com ([71.41.210.146]:56441 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752832Ab1BEC2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 21:28:32 -0500
Date: 4 Feb 2011 21:28:30 -0500
Message-ID: <20110205022830.19500.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dzickus@redhat.com, gorcunov@gmail.com, mingo@elte.hu
Subject: Re: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux@horizon.com,
        ming.m.lin@intel.com, mroos@linux.ee
In-Reply-To: <AANLkTin5gCnhVos3Lu_0GZSxFQmvsNEYTO=Jq7UdmYb1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The earlier patch didn't fix things after all.  I'm rebooting with this one now.

(2.6.38-rc3 wih x86_pmu_start patch.)
Feb  2 01:00:03: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  2 01:00:03: Do you have a strange power saving mode enabled?
Feb  2 01:00:03: Dazed and confused, but trying to continue
Feb  2 01:01:04: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  2 01:01:04: Do you have a strange power saving mode enabled?
Feb  2 01:01:04: Dazed and confused, but trying to continue
Feb  2 04:22:20: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  2 04:22:20: Do you have a strange power saving mode enabled?
Feb  2 04:22:20: Dazed and confused, but trying to continue
Feb  2 06:28:17: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  2 06:28:17: Do you have a strange power saving mode enabled?
Feb  2 06:28:17: Dazed and confused, but trying to continue
Feb  2 08:39:01: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  2 08:39:01: Do you have a strange power saving mode enabled?
Feb  2 08:39:01: Dazed and confused, but trying to continue
Feb  2 16:00:04: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  2 16:00:04: Do you have a strange power saving mode enabled?
Feb  2 16:00:04: Dazed and confused, but trying to continue
Feb  2 20:04:41: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  2 20:04:41: Do you have a strange power saving mode enabled?
Feb  2 20:04:41: Dazed and confused, but trying to continue
Feb  2 22:21:27: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  2 22:21:27: Do you have a strange power saving mode enabled?
Feb  2 22:21:27: Dazed and confused, but trying to continue
Feb  3 00:09:11: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  3 00:09:11: Do you have a strange power saving mode enabled?
Feb  3 00:09:11: Dazed and confused, but trying to continue
Feb  3 00:24:02: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  3 00:24:02: Do you have a strange power saving mode enabled?
Feb  3 00:24:02: Dazed and confused, but trying to continue
Feb  3 01:00:12: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  3 01:00:12: Do you have a strange power saving mode enabled?
Feb  3 01:00:12: Dazed and confused, but trying to continue
Feb  3 01:27:50: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  3 01:27:50: Do you have a strange power saving mode enabled?
Feb  3 01:27:50: Dazed and confused, but trying to continue
Feb  3 06:27:55: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  3 06:27:55: Do you have a strange power saving mode enabled?
Feb  3 06:27:55: Dazed and confused, but trying to continue
Feb  3 09:21:06: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  3 09:21:06: Do you have a strange power saving mode enabled?
Feb  3 09:21:06: Dazed and confused, but trying to continue
Feb  3 11:35:23: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  3 11:35:23: Do you have a strange power saving mode enabled?
Feb  3 11:35:23: Dazed and confused, but trying to continue
Feb  3 17:52:05: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  3 17:52:05: Do you have a strange power saving mode enabled?
Feb  3 17:52:05: Dazed and confused, but trying to continue
Feb  3 18:01:44: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  3 18:01:44: Do you have a strange power saving mode enabled?
Feb  3 18:01:44: Dazed and confused, but trying to continue
Feb  3 18:11:23: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  3 18:11:23: Do you have a strange power saving mode enabled?
Feb  3 18:11:23: Dazed and confused, but trying to continue
Feb  3 20:02:43: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  3 20:02:43: Do you have a strange power saving mode enabled?
Feb  3 20:02:43: Dazed and confused, but trying to continue
Feb  3 22:38:43: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  3 22:38:43: Do you have a strange power saving mode enabled?
Feb  3 22:38:43: Dazed and confused, but trying to continue
Feb  4 01:00:41: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  4 01:00:41: Do you have a strange power saving mode enabled?
Feb  4 01:00:41: Dazed and confused, but trying to continue
Feb  4 05:00:02: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  4 05:00:02: Do you have a strange power saving mode enabled?
Feb  4 05:00:02: Dazed and confused, but trying to continue
Feb  4 06:28:42: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  4 06:28:42: Do you have a strange power saving mode enabled?
Feb  4 06:28:42: Dazed and confused, but trying to continue
Feb  4 13:35:29: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  4 13:35:29: Do you have a strange power saving mode enabled?
Feb  4 13:35:29: Dazed and confused, but trying to continue
Feb  4 20:00:32: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  4 20:00:32: Do you have a strange power saving mode enabled?
Feb  4 20:00:32: Dazed and confused, but trying to continue
Feb  4 21:12:52: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  4 21:12:52: Do you have a strange power saving mode enabled?
Feb  4 21:12:52: Dazed and confused, but trying to continue

