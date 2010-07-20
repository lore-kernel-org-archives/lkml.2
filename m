Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab0GTMHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 08:07:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069Ab0GTMHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 08:07:13 -0400
Message-Id: <20100720120054.875277707@ett.arch.suse.de>
User-Agent: quilt/0.47-15.10
Date: Tue, 20 Jul 2010 14:00:54 +0200
From: trenn@suse.de
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, yehuda@hq.newdream.net
Subject: [patch 0/1] Dynamic Debug providing early boot debug messages via boot parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch is against 2.6.35-rc5. Not sure whether Jason's latest fix is
in there already and whether it conflicts with this series,
but it should patch.

Please tell me if I should (have to) re-diff and against which branch
I should do that.

The patches got boot tested via ddebug_query="file ec.c +p" which worked
out fine.

Would be great to see these in the next kernel cycle (2.6.36).

Thanks,

     Thomas

-- 
£›ÀËÌÀ$Ø²|š³Iâ—\ÆÓbI'zæ¥–¥Å'çç¦Æ'%&gsuØ3³‚%`*™…æ§&(éÇí³}iÕ.•ùäIÒ*i>?†Ù,žµ¬0åm›ç¶øÃ×µ6«77Þ0
