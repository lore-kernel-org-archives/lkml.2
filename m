Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab1CAThW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:37:22 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52544 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab1CAThR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:17 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 14:37:17 EST
Message-Id: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sun, 27 Feb 2011 18:52:24 -0500
Subject: arch/tile: various fixes for 2.6.39
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 01 Mar 2011 19:31:55.0796 (UTC) FILETIME=[530EFD40:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following emails (follow-ups to this one) are all more or less
standalone changes to the arch/tile code, intended for 2.6.39.  Feel free
to skip over the series if you're not interested in Tilera internals.

Patches that either follow up on LKML discussions, or have a wider
distribution than just LKML (e.g. netdev, etc.), I've broken out and
are not part of this series.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
