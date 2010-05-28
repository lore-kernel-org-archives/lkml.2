Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab0E1UrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:47:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54040 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab0E1Uqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:46:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/2] ACPI / ACPICA: GPE reference counting fixes
Date: Fri, 28 May 2010 22:45:19 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Moore, Robert" <robert.moore@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005282245.19382.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

The following two patches fix a few problems introduced by the recent GPE
reference counting changes.

Please review and apply if they make sense to you.

Thanks,
Rafael

