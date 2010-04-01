Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0DAI5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 04:57:14 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39174 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0DAI5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:57:00 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@lists.linbit.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] drbd: potential null dereference
Date: Thu,  1 Apr 2010 10:56:39 +0200
Message-Id: <9736574BB1380E.7050404@linbit.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100327145950.GG5069@bicker>
References: <20100327145950.GG5069@bicker>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan, 

Thanks for the work with the static analyzer, but the patch is
bogus. The lc_element_by_index() function causes a BUG_ON before
returning a NULL. The next mail contains a patch that removes
the unnecessary conditional expression operator.

Philipp Reisner (1):
  drbd: lc_element_by_index() never returns NULL

 drivers/block/drbd/drbd_actlog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

