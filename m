Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1LUTYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:24:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab1LUTYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:24:23 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org
Subject: [PATCH 0/2] Two reiserfs mount options fixes
Date: Wed, 21 Dec 2011 20:23:54 +0100
Message-Id: <1324495436-11203-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  I have fixed two problems with mount options on reiserfs (a bug in quota
option parsing and the fact that mount options were not properly displayed in
/proc/mounts which matters for newer quota tools) and carry following fixes
in my tree. If noone objects, I'll push them to Linus in the next merge window.

									Honza

