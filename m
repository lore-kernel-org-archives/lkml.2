Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1FYW41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 18:56:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58320 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab1FYW4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 18:56:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/3] PM: Fix up interactions between system suspend/resume and runtime PM
Date: Sun, 26 Jun 2011 00:54:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106260054.20578.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patches in this series are related to the interactions between system
suspend/resume and the I/O runtime PM framework.  We've had quite some
confusion and uncertainty in that area recently, so I'd like to clean it
up once and for all, so that everyone knows what the rules are and why
they are what they are.

[1/3] - Update documentation describing interactions between runtime PM and
        system suspend/resume.

[2/3] - Return special error code from runtime PM helers if runtime PM is
        disabled and make the SCSI error handling code take it into account.

[3/3] - Limit race conditions between runtime PM and system suspend/resume.

The patches are on top of the PM domains patchset I've just posted, which is
available from the git branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-domains

Thanks,
Rafael
    
