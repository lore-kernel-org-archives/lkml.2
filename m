Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab1F2Vfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:35:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41289 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877Ab1F2Vf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:35:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/6 v2] PM: Fix up interactions between system suspend/resume and runtime PM
Date: Wed, 29 Jun 2011 23:29:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        linux-scsi@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <201106260054.20578.rjw@sisk.pl>
In-Reply-To: <201106260054.20578.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106292329.04163.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The majority of the patches in the series have been updated and I prepared
two documentation-only patches that are related to this series (posted
previously) and a PCI patch that I thought would be needed for 3.0, but is
only relevant along with [4/6].

On Sunday, June 26, 2011, Rafael J. Wysocki wrote:
> Hi,
> 
> The patches in this series are related to the interactions between system
> suspend/resume and the I/O runtime PM framework.  We've had quite some
> confusion and uncertainty in that area recently, so I'd like to clean it
> up once and for all, so that everyone knows what the rules are and why
> they are what they are.
 
[1/6] - Update documentation describing interactions between runtime PM and
        system suspend/resume.

[2/6] - Return special error code from runtime PM helers if runtime PM is
        disabled and make the SCSI error handling code take it into account.

[3/6] - Add early wakeup events detection to the PCI bus type.

[4/6] - Limit race conditions between runtime PM and system suspend/resume.

[5/6] - Fix descriptions of pm_runtime_enable/disable() and add a description
        of pm_runtime_barrier() to the runtime PM documentation.

[6/6] - Replace "run-time" with "runtime" everywhere in the runtime PM
        documentation and kerneldoc comments.

The patches are on top of the PM domains patchset I've just posted, which is
available from the git branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-domains

They are regarded as 3.1 material.

Thanks,
Rafael
