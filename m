Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab1JMRdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:33:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48551 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab1JMRdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:33:04 -0400
Date: Thu, 13 Oct 2011 13:33:01 -0400 (EDT)
Message-Id: <20111013.133301.432417802471753173.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ide: fix for ide_timing quantisation errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <201110131516.03408.bzolnier@gmail.com>
References: <201110131516.03408.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 13 Oct 2011 10:33:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Thu, 13 Oct 2011 15:16:03 +0200

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH v2] ide: fix for ide_timing quantisation errors
> 
> Based on commit 4f701d1 ("ata_timing: ensure t->cycle is always
> correct") for libata.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

I'm not applying patches that sync up the ATA layer with the IDE layer
in ways like this unless the change is in response to a user reported
bug.

We're way past the stage where we are making changes to the IDE
layer based purely upon visual inspection.  I want a real user
bug report to back most if not all changes.

These two layers will get out of sync, and you're going to have to
accept that.  Please concentrate your efforts on the ATA layer
if you want to make cleanups, simplifications, and fixes based
upon code audits.
