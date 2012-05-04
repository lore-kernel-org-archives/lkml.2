Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2EDINx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 04:13:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:6829 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab2EDINu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 04:13:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="138801413"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>, Zheng Yan <zheng.z.yan@intel.com>
Subject: [RFC v2 0/5] PCIe, Add PCIe runtime D3cold support
Date: Fri,  4 May 2012 16:13:36 +0800
Message-Id: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add runtime D3cold support to PCIe.

Changelog:

v2: Refreshed based on comments from Rafael

[RFC v2 1/5] PM, Runtime, Add power_must_be_on flag
[RFC v2 2/5] PM, Add sysfs file power_off to control device power off
[RFC v2 3/5] PCIe, Add runtime PM support to PCIe port
[RFC v2 4/5] ACPI, PM, Specify lowest allowed state for device sleep
[RFC v2 5/5] PCIe, Add PCIe runtime D3cold support
