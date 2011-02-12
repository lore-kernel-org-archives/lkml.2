Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab1BLWPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 17:15:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab1BLWPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 17:15:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/2] PM: Core power management modifications
Date: Sat, 12 Feb 2011 23:12:26 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <201101300107.19389.rjw@sisk.pl> <87sjw7wvjl.fsf@ti.com> <201102011939.49793.rjw@sisk.pl>
In-Reply-To: <201102011939.49793.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102122312.26545.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The two patches in this series modify the core power management code in the
following way:

[1/2] - Adds support for device power domains.
[2/2] - Reworks the core PM routines so that subsystems are treated in the
        same way by the system-wide transitions code and the runtime PM code.

Comments welcome!

Thanks,
Rafael

