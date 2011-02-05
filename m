Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1BEJPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 04:15:39 -0500
Received: from science.horizon.com ([71.41.210.146]:19458 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751263Ab1BEJPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 04:15:38 -0500
Date: 5 Feb 2011 04:15:36 -0500
Message-ID: <20110205091536.11125.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: gorcunov@gmail.com, linux@horizon.com
Subject: Re: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test
Cc: a.p.zijlstra@chello.nl, dzickus@redhat.com, linux-kernel@vger.kernel.org,
        ming.m.lin@intel.com, mingo@elte.hu, mroos@linux.ee
In-Reply-To: <4D4D0D1A.8020502@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi George, this log is when unflagged overflow patch applied or previous one?

The earlier one.  As I said, the patch to x86_pmu_start.  The later one (no
complaints in 6 hours of uptime so far) was to p4_pmu_clear_cccr_ovf.

Thank you very much!
