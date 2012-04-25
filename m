Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2DYU6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:58:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757708Ab2DYU54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:57:56 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, bfields@fieldses.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 0/6] Get rid of I_MUTEX_QUOTA use
Date: Wed, 25 Apr 2012 22:57:41 +0200
Message-Id: <1335387467-4928-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello,

  this patch set changes generic quota code (and filesystems relying on it)
so that they don't use special locking class I_MUTEX_QUOTA. The only remaining
user of I_MUTEX_QUOTA is GFS2. If noone has objections, I can merge these
patches through my tree or Bruce, you can take them as your work depends
on these changes.

								Honza
