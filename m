Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0JROiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:38:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450Ab0JROhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:53 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 18/22] GFS2: Add "norecovery" mount option as a synonym for "spectator"
Date: Mon, 18 Oct 2010 15:15:42 +0100
Message-Id: <1287411346-17855-19-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XFS supports the "norecovery" mount option which is basically the
same as the GFS2 spectator mode. This adds support for "norecovery"
as a synonym for spectator mode, which is hopefully a more obvious
description of what it actually does.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index d85e0b7..047d117 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -85,6 +85,7 @@ static const match_table_t tokens = {
 	{Opt_locktable, "locktable=%s"},
 	{Opt_hostdata, "hostdata=%s"},
 	{Opt_spectator, "spectator"},
+	{Opt_spectator, "norecovery"},
 	{Opt_ignore_local_fs, "ignore_local_fs"},
 	{Opt_localflocks, "localflocks"},
 	{Opt_localcaching, "localcaching"},
-- 
1.7.1.1

