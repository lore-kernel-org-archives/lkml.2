Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0FHJAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:00:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37145 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab0FHJAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:00:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/5] ACPI / ACPICA: Fix problems related to GPE reference counting
Date: Tue, 8 Jun 2010 10:46:48 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Len Brown <len.brown@intel.com>, Zhang Rui <rui.zhang@intel.com>
References: <201006080024.46142.rjw@sisk.pl>
In-Reply-To: <201006080024.46142.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006081046.48488.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I decided to split this big patch into a series of smaller ones addressing one
issue each.  I think all of the issues addressed by [2-5/5] may be regarded as
regressions from 2.6.33, because that kernel didn't have these problems.

[1/5] - Not really a fix, but [2/5] depends on it and I don't see a reason to
        duplicate that thing even more.
[2/5] - Low-level GPE manipulation fix
[3/5] - Fix possible issue with re-enabling a GPE after event handling
[4/5] - Fix the initialization of GPEs
[5/5] - Fix GPE sysfs interface

Please review, possibly apply.

Thanks,
Rafael

