Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab0LUBlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:41:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933396Ab0LUBlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:41:52 -0500
From: Dave Airlie <airlied@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: vt/fbcon binding and handover fixes
Date: Tue, 21 Dec 2010 11:41:14 +1000
Message-Id: <1292895677-4242-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been working on some issues with the fb handoff between vesafb and KMS
on my machine with a dual-gpu card. These 3 patches are the primary result
of this, to fix a number of issues where the VT layer and fbcon layers
got themselves into a place that they couldn't get out off, having the second
card complicates things nicely where we have an fbdev registered but fbcon
gets unbound to the dummy console and can't get back.

Also a fix to the overlap tests which had an off-by-one.

Dave.

