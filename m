Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1COKVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 06:21:49 -0400
Received: from verein.lst.de ([213.95.11.211]:39900 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab1COKVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 06:21:47 -0400
Date: Tue, 15 Mar 2011 11:21:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [RFC-v2 06/12] iscsi-target: Add iSCSI Login Negotiation and
	Parameter logic
Message-ID: <20110315102146.GA24496@lst.de>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org> <1300103829-10337-7-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300103829-10337-7-git-send-email-nab@linux-iscsi.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thread pool in iscsi_thread_queue.c looks like it really should
go away in favour of the new concurrency managed workqueues.  Did you look
into the current kernel kernel/workqueue.c code?

