Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0E1HEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:04:06 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:58850 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0E1HEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:04:00 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: idle patches for 2.6.35
Date: Fri, 28 May 2010 02:01:53 -0400
Message-id: <1275026521-30835-1-git-send-email-lenb@kernel.org>
X-Mailer: git-send-email 1.7.1.231.gd0b16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series responds to all the feedback I've received.

I believe that this series is useful enough and clean enough
to merit inclusion upstream.

Please look it over and try it out and let me know what I missed.

thanks,
Len Brown, Intel Open Source Technology Center

ps.
Note that you can get the patch series as a single patch here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.34/idle-test-2.6.34.diff.gz

or pull from this git branch
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-test

Note that I updated the series "in place", changing git history.
So if you previously pulled from idle-test, you'll want to
discard that branch and create a new one based on 2.6.34.

