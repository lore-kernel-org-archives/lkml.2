Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1EDDGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 23:06:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:2301 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab1EDDGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 23:06:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,312,1301900400"; 
   d="scan'208";a="430025896"
From: Chen Gong <gong.chen@linux.intel.com>
To: tony.luck@intel.com, ying.huang@intel.com
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 0/3] pstore: fix some errors when erst as the interface
Date: Wed,  4 May 2011 11:06:49 +0800
Message-Id: <1304478412-11843-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.5.185.g0b9dee
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/3] fix one type of return value in pstore
[PATCH 2/3] fix pstore filesystem mount/remount issue
[PATCH 3/3] fix potential logic issue in pstore read interface

These patches fix some potential errors for pstore when erst as
the underlying interface. And fix a pstore filesystem mount/remount
issue.
