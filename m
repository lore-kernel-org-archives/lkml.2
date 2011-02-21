Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab1BUP6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:58:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:38088 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab1BUP6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:58:47 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Milton Miller <miltonm@bga.com>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] aio: Fix use after free bugs
Date: Mon, 21 Feb 2011 16:58:29 +0100
Message-Id: <1298303911-11413-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Andrew,

  The following two patches fix use after free bugs in AIO code.  Could you
please merge them? Thanks.

								Honza
