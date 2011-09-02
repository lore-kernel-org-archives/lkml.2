Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1IBWy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 18:54:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab1IBWy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 18:54:26 -0400
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2 v3] Small cleanup of bdi_forker_thread()
Date: Sat,  3 Sep 2011 00:54:17 +0200
Message-Id: <1315004059-9844-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Jens,

  so after I realized how I underestimated subtlety of bdi_forker_thread()
here are two small cleanups to it. The first one puts clearing of BDI_pending
in a more natural place, the second patch adds a comment so that fools like
me don't try to optimize the function in a wrong place...

								Honza
