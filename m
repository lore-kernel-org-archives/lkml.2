Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1FZU7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 16:59:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59214 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab1FZU6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 16:58:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 0/2] PM / Runtime: Documentation improvements
Date: Sun, 26 Jun 2011 22:57:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106262257.10769.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches improve the runtime PM documentation,
on top of the recent "PM: Fix up interactions between system
suspend/resume and runtime PM" series.

[1/2] - Fix documentation of pm_runtime_enable(), pm_runtime_disable()
        and add description of pm_runtime_barrier().

[2/2] - Consolidate the spelling of "runtime".

Thanks,
Rafael

