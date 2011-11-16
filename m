Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab1KPCdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 21:33:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:45613 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984Ab1KPCdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 21:33:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,518,1315206000"; 
   d="scan'208";a="91092246"
From: Chen Gong <gong.chen@linux.intel.com>
To: tony.luck@intel.com
Cc: andi.kleen@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH ] [RESEND] x86: add IRQ context simulation in module mce-inject
Date: Wed, 16 Nov 2011 10:35:07 +0800
Message-Id: <1321410908-1773-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resend this patch including x86@kernel.org maillist.
