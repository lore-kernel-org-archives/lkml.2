Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab0IXM2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:28:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0IXM2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:28:33 -0400
From: Thomas Renninger <trenn@suse.de>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, bjorn.helgaas@hp.com, jbaron@redhat.com
Subject: Dynamic Debug module.ddebug fake param enhancements V4
Date: Fri, 24 Sep 2010 14:28:27 +0200
Message-Id: <1285331311-21753-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20100920184441.GA2915@redhat.com>
References: <20100920184441.GA2915@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches are intended for Greg's tree and depend on 3 other
dynamic debug patches which already are in linux-next, but not in
the vanilla kernel yet.

[PATCH 1/4] Dynamic Debug: Introduce global fake module param module.ddebug - V4
     V3 -> V4: Do not put that large arrays on the stack, make one func __init

[PATCH 2/4] PNP: Compile all pnp built-in stuff in one module namespace
[PATCH 3/4] PNP: Use dev_dbg instead of dev_printk(KERN_DEBUG.. if DYNAMIC_DEBUG is compiled in
  -> Compile PNP subsystem in a separate pnp module namespace

[PATCH 4/4] kernel/module.c: Fix compiler warnings if debug is compiled in
  -> minor compile fixup

Only the two PNP patches really belong together.
If someone e.g. complains about the PNP patches, please still submit the rest.

Thanks,

      Thomas

