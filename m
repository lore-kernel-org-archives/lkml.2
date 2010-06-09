Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab0FIAiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 20:38:15 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:59796 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756486Ab0FIAiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 20:38:12 -0400
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [PATCH 0/3] writeback: bug fixes for 2.6.35
Date: Wed,  9 Jun 2010 10:37:17 +1000
Message-Id: <1276043840-1946-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a resend of my current writeback bug fixes without the preceding
tracing patches.  Please consider these for 2.6.35 as they are fixes for
regressions introduced in previous kernel releases.

Cheers,

Dave.

