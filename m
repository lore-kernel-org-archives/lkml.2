Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925Ab0DHXit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:38:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41594 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349Ab0DHXir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:38:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/2] ACPI / EC / PM: Fix race between EC transactions and suspend/hibernate process
Date: Fri, 9 Apr 2010 01:38:13 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
Message-Id: <201004090138.13522.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

The following two patches fix BKO #14668.  The first one is the actual fix
and the other one changes the names of the involved functions so that they
better reflect what's done.

Please apply.

Rafael

