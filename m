Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab0IOWLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:11:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0IOWLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:11:51 -0400
From: Thomas Renninger <trenn@suse.de>
To: trenn@suse.de
Cc: bjorn.helgaas@hp.com, gregkh@suse.de, jbaron@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Dynamic Debug module.ddebug fake param enhancements
Date: Thu, 16 Sep 2010 00:11:44 +0200
Message-Id: <1284588708-54170-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the replacment of a patch Greg queued up recently, but it had issues.

I am not happy with some parts of the code, but it works:
Compile tested on different architectures with different .configs
Tested on X86 32 and 64 bit.

Cleanups, comments, suggestions are very welcome.
I spent more time on this as expected. I can take care for minor
cleanups, etc. and repost.
Jason: if it gets more, you have to take over again, sorry.

I picked out the pnp layer to show ddebug enhancements and how built-in
drivers/components can make use of it.
First I thought about pci, but some parts are initialized long before
dynamic debug, still similar changes might also make sense there.

    Thomas


