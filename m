Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1BFNVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 08:21:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47709 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab1BFNVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 08:21:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/2] ACPI / PM: Fix suspend regression related to button GPEs
Date: Sun, 6 Feb 2011 14:18:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Ferenc =?utf-8?q?W=C3=A1gner?= <wferi@niif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102061418.56202.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first of the following patches fixes the suspend regression tracked in
References: https://bugzilla.kernel.org/show_bug.cgi?id=27372
and the second one corrects a small ugliness in the button driver.

Please apply!

Thanks,
Rafael

