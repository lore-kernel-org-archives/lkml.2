Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab1DMDTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 23:19:08 -0400
Received: from science.horizon.com ([71.41.210.146]:27154 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756020Ab1DMDTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 23:19:06 -0400
Date: 12 Apr 2011 23:19:04 -0400
Message-ID: <20110413031904.9276.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dzickus@redhat.com, gorcunov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Cc: a.p.zijlstra@chello.nl, airlied@gmail.com, eranian@google.com,
        linux@horizon.com, ming.m.lin@intel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This problem which I thought was fixed by commit 7d44ec193d, appears to be
still very much present in 2.6.39-rc3:

Apr 12 22:16:00 horizon kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Apr 12 22:16:00 horizon kernel: Do you have a strange power saving mode enabled?
Apr 12 22:16:00 horizon kernel: Dazed and confused, but trying to continue
Apr 12 22:17:22 horizon kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Apr 12 22:17:22 horizon kernel: Do you have a strange power saving mode enabled?
Apr 12 22:17:22 horizon kernel: Dazed and confused, but trying to continue
Apr 12 22:21:17 horizon kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Apr 12 22:21:17 horizon kernel: Do you have a strange power saving mode enabled?
Apr 12 22:21:17 horizon kernel: Dazed and confused, but trying to continue
Apr 12 22:25:02 horizon kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Apr 12 22:25:02 horizon kernel: Do you have a strange power saving mode enabled?
Apr 12 22:25:02 horizon kernel: Dazed and confused, but trying to continue
Apr 12 22:28:24 horizon kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Apr 12 22:28:24 horizon kernel: Do you have a strange power saving mode enabled?
Apr 12 22:28:24 horizon kernel: Dazed and confused, but trying to continue
Apr 12 22:31:28 horizon kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Apr 12 22:31:28 horizon kernel: Do you have a strange power saving mode enabled?
Apr 12 22:31:28 horizon kernel: Dazed and confused, but trying to continue
Apr 12 22:34:20 horizon kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Apr 12 22:34:20 horizon kernel: Do you have a strange power saving mode enabled?
Apr 12 22:34:20 horizon kernel: Dazed and confused, but trying to continue
Apr 12 22:37:01 horizon kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Apr 12 22:37:01 horizon kernel: Do you have a strange power saving mode enabled?
Apr 12 22:37:01 horizon kernel: Dazed and confused, but trying to continue

Same system as before: 1.6 GHz P4, ASUS P4B266LA, Intel 845 chipset.

I suspect commit 242214f9c1 wasn't quite as effective as hoped.
