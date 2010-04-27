Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0D0GnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 02:43:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:61927 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab0D0GnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 02:43:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,278,1270450800"; 
   d="scan'208";a="616765449"
From: Huang Ying <ying.huang@intel.com>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org,
       linux-acpi@vger.kernel.org
Subject: ACPI, APEI support
Date: Tue, 27 Apr 2010 14:41:09 +0800
Message-Id: <1272350481-27951-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset adds the APEI (ACPI Platform Error Interface) support to
Linux kernel.

01-06 include the basic APEI HEST parsing and EINJ support. They have
been posted to mailing list before and get some reviews and
ACKs. Changes since the last post are as follow.

- Make APEI infrastructure and HEST parsing configurable built-in
  instead of modules to solve some dependency issues.

- Some minor fixes, such as printk

07-10 are newly added to support GHES (Generic Hardware Error Source)
corrected memory error. On some machines, Machine Check can not report
physical address for some corrected memory errors, but GHES can do
that. So this simplified GHES is implemented and posted firstly.

11-12 are newly added to support using ERST for persistent storage of
MCE. This can improve fatal MCE report.

[PATCH 01/12] ACPI, IO memory pre-mapping and atomic accessing
[PATCH 02/12] ACPI, APEI, APEI supporting infrastructure
[PATCH 03/12] ACPI, APEI, HEST table parsing
[PATCH 04/12] ACPI, APEI, EINJ support
[PATCH 05/12] ACPI, APEI, Document for APEI
[PATCH 06/12] ACPI, APEI, PCIE AER, use general HEST table parsing in AER firmware_first setup
[PATCH 07/12] ACPI Hardware Error Device (PNP0C33) support
[PATCH 08/12] Unified UUID/GUID definition
[PATCH 09/12] ACPI, APEI, UEFI Common Platform Error Record (CPER) header
[PATCH 10/12] ACPI, APEI, Generic Hardware Error Source memory error support
[PATCH 11/12] ACPI, APEI, Error Record Serialization Table (ERST) support
[PATCH 12/12] ACPI, APEI, Use ERST for persistent storage of MCE

