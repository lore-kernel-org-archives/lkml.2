Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0CVSiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:38:22 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45213 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0CVSiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:38:19 -0400
From: Borislav Petkov <bp@amd64.org>
To: <akpm@linux-foundation.org>, davej@redhat.com
Cc: cpufreq@vger.kernel.org, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] powernow-k8: Core Performance Boost and effective frequency support
Date: Mon, 22 Mar 2010 19:38:36 +0100
Message-Id: <1269283121-11894-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

here's a small patchset that implements two new performance-related
features on AMD: Core Performance Boost and Effective Frequency
reporting (APERF/MPERF). Details for each are to be found in the
respective commit messages, as Andrew requested :).

 5/5 overloads the /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq
interface to show the actual core frequency when boosting. Let me know
if the way it is done is agreeable.

Thanks,
Boris.
