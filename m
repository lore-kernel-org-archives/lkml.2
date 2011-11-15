Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab1KOXto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:49:44 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10391 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab1KOXtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:49:33 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6531"; a="135645116"
From: Laura Abbott <lauraa@codeaurora.org>
To: catalin.marinas@arm.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-msm@vger.kernel.org
Subject: [RFC PATCH] kmemleak: Add support for memory hotplug
Date: Tue, 15 Nov 2011 15:49:08 -0800
Message-Id: <1321400949-1852-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, kmemleak is not supported with memory hotplug. This has
been discussed before[1] but never really went anywhere. Catalin's
other suggestion was to add callbacks for memory hotplug but given
there is now a nice lock_memory_hotplug function, this seems like
the right place to call it. Down the road call backs could be added
but this should hopefully enable hotplug to be used with kmemleak.

-Laura

[1] https://lkml.org/lkml/2010/3/22/395

