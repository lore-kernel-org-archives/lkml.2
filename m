Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1HHHEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 03:04:04 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:11427 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954Ab1HHHD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 03:03:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUHAMKHP055LbAB/2dsb2JhbABCmDGPBniCHSMYgQIDxCiGRgSjfA
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/2] dcache: per-sb LRU locks
Date: Mon,  8 Aug 2011 17:03:39 +1000
Message-Id: <1312787021-11324-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

This is the missing piece of the per-sb shrinker patchset - I
dropped it because it was causing problems. Now that you've fixed a
bunch of problems in the dcache code, the conversion to per-sb LRU
locks for the dcache no longer causes my systems to crash and burn.
It's been stable for the past couple of weeks, so it's time for more
review and wider testing....

Cheers,

Dave.
