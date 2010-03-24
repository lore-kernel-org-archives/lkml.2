Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab0CXRqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:46:01 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58654 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab0CXRp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:45:57 -0400
From: Borislav Petkov <bp@amd64.org>
To: <akpm@linux-foundation.org>, davej@redhat.com, trenn@suse.de,
       linux@dominikbrodowski.net
Cc: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>,
       cpufreq@vger.kernel.org, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] powernow-k8: Core Performance Boost and effective frequency support
Date: Wed, 24 Mar 2010 18:46:18 +0100
Message-Id: <1269452783-966-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

here's the reworked version after incorporating most of your comments.

In particular, this version adds a /proc/cpuinfo flag and removes the
scaling_cur_freq interface overload in favor of cpufreq-aperf userspace
tool.

Please review,
thanks.

Changelog:

v0: initial submission


-- 
Regards/Gruss,
Boris.
