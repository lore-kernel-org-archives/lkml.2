Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab2BGWh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:37:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757133Ab2BGWhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:37:54 -0500
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        mpatocka@redhat.com, sandeen@sandeen.net
Subject: [PATCH 0/2] Fix deadlock with suspend & quotas
Date: Tue,  7 Feb 2012 23:37:45 +0100
Message-Id: <1328654267-18855-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello Al,

  This is my attempt to fix deadlock in quota code when filesystem is
suspended and someone tries to modify quota e.g. via Q_SETQUOTA command. I
added a VFS function to get a superblock reference and return only after
the filesystem is thawed. Is that what you had in mind? Can you merge
these patches? Thanks.

								Honza
