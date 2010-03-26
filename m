Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0CZNji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:39:38 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57903 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab0CZNja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:39:30 -0400
From: Borislav Petkov <bp@amd64.org>
To: <akpm@linux-foundation.org>, davej@redhat.com
Cc: trenn@suse.de, linux@dominikbrodowski.net, <mingo@elte.hu>,
       <hpa@zytor.com>, <tglx@linutronix.de>, cpufreq@vger.kernel.org,
       <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [-v2 PATCH 0/6] powernow-k8: Core Performance Boost and effective frequency support
Date: Fri, 26 Mar 2010 14:39:54 +0100
Message-Id: <1269610800-23847-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

here's the next version. This one adds only the move of APERF/MPERF
cpuid fragment to vendor-agnostic x86 init path, as Thomas suggested.

Changelog:

v1: add a /proc/cpuinfo flag and remove the scaling_cur_freq interface
overload in favor of cpufreq-aperf userspace tool.

v0: initial submission


-- 
Regards/Gruss,
Boris.
