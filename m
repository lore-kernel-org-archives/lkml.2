Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab0CaT4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:56:10 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41152 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab0CaT4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:56:05 -0400
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <akpm@linux-foundation.org>
Cc: davej@redhat.com, trenn@suse.de, linux@dominikbrodowski.net,
       cpufreq@vger.kernel.org, <linux-kernel@vger.kernel.org>,
       <x86@kernel.org>
Subject: [-v3 PATCH 0/6] powernow-k8: Core Performance Boost and effective frequency support
Date: Wed, 31 Mar 2010 21:56:40 +0200
Message-Id: <1270065406-1814-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

ok, this should be the final version of the patchset. It adds the
suggested changes to patch 2/6 and also a CPU hotplug notifier which
takes care of the boosting flag when off-/onlining CPUs so that the
remaining can still boost.

Changelog:

v2: add only the move of APERF/MPERF cpuid fragment to vendor-agnostic
x86 init path, as Thomas suggested.

v1: add a /proc/cpuinfo flag and remove the scaling_cur_freq interface
overload in favor of cpufreq-aperf userspace tool.

v0: initial submission


-- 
Regards/Gruss,
Boris.
