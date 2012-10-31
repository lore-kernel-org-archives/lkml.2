Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab2JaRph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:45:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759474Ab2JaRpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:45:30 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC EDAC/GHES 0/3] Add EDAC support on GHES
Date: Wed, 31 Oct 2012 15:44:52 -0200
Message-Id: <cover.1351705248.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns that making ghes to talk with EDAC to not be a hard
task.

This patch series makes ghes->edac integration.

This was compile-tested only, as its, for now, just a proof of
concept.

There are lots of space for improvements, like:

- maybe split edac-ghes into a separate file;

- add a way to retrieve the DIMM label (not sure if APEI GHES
  interface supports it);

- detect the memory layout via ACPI;

Comments, sugestions etc are welcome.

Mauro Carvalho Chehab (3):
  ghes: Be a good citzen with EDAC
  edac: add support for raw error reports
  ghes: add support for reporting errors via EDAC

 drivers/acpi/apei/Kconfig  |   1 +
 drivers/acpi/apei/Makefile |   2 +
 drivers/acpi/apei/ghes.c   | 129 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/edac/edac_core.h   |  17 ++++++
 drivers/edac/edac_mc.c     | 109 ++++++++++++++++++++++++++++----------
 include/linux/edac.h       |   5 ++
 6 files changed, 233 insertions(+), 30 deletions(-)

-- 
1.7.11.7

