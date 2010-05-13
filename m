Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0EMCJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:09:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:51202 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab0EMCJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:09:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,218,1272870000"; 
   d="scan'208";a="276508020"
From: Huang Ying <ying.huang@intel.com>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org,
       linux-acpi@vger.kernel.org
Subject: [PATCH -v2 0/2] ACPI, APEI EINJ injection parameters support
Date: Thu, 13 May 2010 10:09:21 +0800
Message-Id: <1273716563-23573-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch queue is based on acpi-test.git.

Changelog:

v2:

- Remove uninject support, because it is not implemented in BIOS properly now.
