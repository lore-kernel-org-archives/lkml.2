Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1BOM7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:59:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab1BOM7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:59:32 -0500
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] aio: Fix use after free bugs
Date: Tue, 15 Feb 2011 13:59:22 +0100
Message-Id: <1297774764-32731-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Al,

  The following two patches fix use after free bugs in AIO code.  I'm not
completely sure you're the right one to merge these but hopefully yes ;).
Could you please merge them? Thanks.

								Honza
