Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab1E3RjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 13:39:19 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:34518 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1E3RjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 13:39:18 -0400
Date: Mon, 30 May 2011 19:39:16 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Very high CPU values in top on idle system (3.0-rc1)
Message-ID: <20110530173916.GA1746@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get very high CPU values when I run 'top' on my (mostly) idle system
with 3.0-rc1. For example mpd was always in the 1-2% range and is now
constantly over 50%. 

This is caused by:

commit 317f394160e9beb97d19a84c39b7e5eb3d7815a8
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Tue Apr 5 17:23:58 2011 +0200

    sched: Move the second half of ttwu() to the remote cpu

When I revert the above I see sane CPU values again.
-- 
Markus
