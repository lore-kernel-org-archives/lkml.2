Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188Ab1JER6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:58:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab1JER6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:58:35 -0400
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Avoid putting of writeback of inodes for too long (v3)
Date: Wed,  5 Oct 2011 19:58:17 +0200
Message-Id: <1317837499-9842-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

  this patch series improves writeback code so that we don't put of writeback
of inodes for unnecessarily long in some cases. A prerequisite for this is an
improved livelock prevention which is done by the first patch. Christoph, can
you verify whether these two patches help your problems with writeback of XFS
inodes being put off almost indefinitely please? Thanks.

								Honza
