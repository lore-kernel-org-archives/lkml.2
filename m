Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1APNLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:11:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34843 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1APNL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:11:27 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 16 Jan 2011 14:11:05 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Message-ID: <20110116141105.59e5b3a2@stein>
In-Reply-To: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15 Nicholas A. Bellinger wrote:
> This patch changes configfs to select SYSFS to fix the following:
> 
> warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)

Why don't you fix target-core's Kconfig instead?

> This patch also fixes whitespace breakage in the 'help' section.

There is no whitespace breakage in fs/configfs/Kconfig.
-- 
Stefan Richter
-=====-==-== ---= =----
http://arcgraph.de/sr/
