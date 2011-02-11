Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab1BKWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:25:57 -0500
Received: from adelie.canonical.com ([91.189.90.139]:53500 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab1BKWZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:25:55 -0500
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: [Patch] mmc: add ricoh 0xe823 pci id
Date: Fri, 11 Feb 2011 16:25:30 -0600
Message-Id: <1297463131-3557-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch enables RICOH MMC card reader with pci id 0xe823. 

