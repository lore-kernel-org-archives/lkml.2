Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab2KEOfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:35:12 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:44072 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477Ab2KEOfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:35:10 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] 4 fixes for drbd
Date: Mon, 05 Nov 2012 15:35:07 +0100
Message-ID: <1433815.PN8uhmSntl@fat-tyre>
User-Agent: KMail/4.8.5 (Linux/3.2.0-32-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121101100658.GM27975@kernel.dk>
References: <3728568.yDZLErye6B@fat-tyre> <20121101100658.GM27975@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Can you rebase this against for-3.8/drivers? Thanks.

Hi Jens,

One of these changes fixes a regression that was introduced in the last
merge window. Please consider to pull this single commit.
(I will rebase the other 3 commit on for-3.8/drivers)


The following changes since commit a13c29ddf73d3be4fbb2b1bbced64014986cd87a:
  Jens Axboe (1):
        Merge branch 'for-jens' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block into for-3.7/drivers

are available in the git repository at:

  git://git.drbd.org/linux-drbd.git for-jens

Lars Ellenberg (1):
      drbd: fix regression: potential NULL pointer dereference

 drivers/block/drbd/drbd_int.h  |    5 +++++
 drivers/block/drbd/drbd_main.c |    8 ++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)


