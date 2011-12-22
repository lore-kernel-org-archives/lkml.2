Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1LVX2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:28:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab1LVX22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:28:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 0/2] PM / Sleep: Introduce new phases of device suspend/resume
Date: Fri, 23 Dec 2011 00:29:19 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112230029.20174.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On the request of some driver PM developers, that appears to have been quite
popular lately, this series of patches adds new system suspend/resume (and
hibernation/restore) callbacks to struct dev_pm_ops and makes the PM core
use them during system power transitions.

[1/2] - Introduce "late suspend" and "early resume" of devices.
[2/2] - Introduce generic callbacks for new device PM phases.

The series is on top of the linux-next branch of the linux-pm tree.

These patches have been tested on Toshiba Portege R500 with openSUSE 12.1
without crashing the box in the process, which looks promising.  Also,
they shouldn't actually have any impact on the existing setups other than
adding a very short delay to the system suspend/resume code paths.

Comments welcome!

Thanks,
Rafael

