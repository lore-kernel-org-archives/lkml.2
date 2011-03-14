Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab1CNO6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:58:11 -0400
Received: from verein.lst.de ([213.95.11.211]:53555 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab1CNO6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:58:09 -0400
Date: Mon, 14 Mar 2011 15:58:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 21/21] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
	module
Message-ID: <20110314145808.GA28480@lst.de>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org> <1300100775-10012-22-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300100775-10012-22-git-send-email-nab@linux-iscsi.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 04:06:15AM -0700, Nicholas A. Bellinger wrote:
>  drivers/target/Kconfig                         |    2 +
>  drivers/target/Makefile                        |    3 +
>  drivers/target/tcm_loop/Kconfig                |   11 +
>  drivers/target/tcm_loop/Makefile               |    5 +
>  drivers/target/tcm_loop/tcm_loop_configfs.c    |  643 ++++++++++++++++++++++++
>  drivers/target/tcm_loop/tcm_loop_core.h        |  141 ++++++
>  drivers/target/tcm_loop/tcm_loop_fabric.c      |  472 +++++++++++++++++
>  drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |  574 +++++++++++++++++++++
>  8 files changed, 1851 insertions(+), 0 deletions(-)

Please descide on a naming scheme for the frontend modules.  You have
tcm_loop for thise one, and just iscsi for the iscsi frontend.  I'm
not sure what tcm actually stands for, but a common prefix defintively
is helpful.

And for only about 1700 lines of code I really don't see why it needs to be
split into multiple implementation files.

