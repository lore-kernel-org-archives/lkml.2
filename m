Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1APVxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:53:32 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:50290 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab1APVxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:53:31 -0500
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <20110116141105.59e5b3a2@stein>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
	 <20110116141105.59e5b3a2@stein>
Content-Type: text/plain
Date: Sun, 16 Jan 2011 13:53:27 -0800
Message-Id: <1295214807.22813.57.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-16 at 14:11 +0100, Stefan Richter wrote:
> On Jan 15 Nicholas A. Bellinger wrote:
> > This patch changes configfs to select SYSFS to fix the following:
> > 
> > warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)
> 
> Why don't you fix target-core's Kconfig instead?

The thought here was that since modern configfs is mounted
at /sys/kernel/config/, selecting SYSFS by default when building
CONFIGFS_FS made the most sense for existing configfs consumers.

> > This patch also fixes whitespace breakage in the 'help' section.
> 
> There is no whitespace breakage in fs/configfs/Kconfig.

Fixed in scsi-post-merge-2.6.git/for-linus.  Thanks for your comments!

--nab

