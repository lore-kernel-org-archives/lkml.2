Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab1KIBXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:23:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49036 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab1KIBXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:23:41 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 0/8] Initial DT clock bindings
Date: Tue,  8 Nov 2011 18:19:35 -0700
Message-Id: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all, here is an initial implementation of the DT clock bindings
with the versatile platform modified to use them.  I'm fairly happy
with how this has turned out, although I'll probably roll the clock
lookup stuff directly into drivers/clk/clkdev.c which will simplify
things a bit.  Please take a look and comment.

You'll also notice that I've started adding selftests to the
devicetree code, which turned out to be pretty useful for debugging.
I think I want to do this for a lot of the dt infrastructure.

The first 5 patches are probably pretty close to ready to be merged,
the last 3 I expect to still need work.

g.

