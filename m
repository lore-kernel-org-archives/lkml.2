Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1BHO0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:26:18 -0500
Received: from science.horizon.com ([71.41.210.146]:33798 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754094Ab1BHO0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:26:17 -0500
Date: 8 Feb 2011 09:26:15 -0500
Message-ID: <20110208142615.19960.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dzickus@redhat.com, gorcunov@gmail.com
Subject: Re: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test
Cc: a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        linux-kernel@vger.kernel.org, linux@horizon.com, ming.m.lin@intel.com,
        mingo@elte.hu, mroos@linux.ee
In-Reply-To: <4D502A4D.1040301@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't use kgdb, so I can't comment on that, but patch #2
("perf, x86: P4 PMU -- Fix unflagged overflows test")
has given me no problems in 3.5 days of uptime.

Thank you very much!
