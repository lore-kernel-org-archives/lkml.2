Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0CYP2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:28:23 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:25678 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab0CYP2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:28:21 -0400
Subject: [PATCH 0/2] x86/PCI: truncate _CRS windows with _LEN > _MAX - _MIN + 1
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yanko Kaneti <yaneti@declera.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
Date: Thu, 25 Mar 2010 09:28:19 -0600
Message-ID: <20100325152750.10117.81615.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix a "pci=use_crs" regression and print a little more
debug information for resource allocation conflicts.

---

Bjorn Helgaas (2):
      x86/PCI: for host bridge address space collisions, show conflicting resource
      x86/PCI: truncate _CRS windows with _LEN > _MAX - _MIN + 1


 arch/x86/pci/acpi.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)
