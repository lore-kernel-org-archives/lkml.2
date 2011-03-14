Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1CNO7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:59:32 -0400
Received: from verein.lst.de ([213.95.11.211]:53598 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab1CNO7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:59:31 -0400
Date: Mon, 14 Mar 2011 15:59:30 +0100
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
Subject: Re: [RFC-v2 01/12] iscsi: Resolve iscsi_proto.h naming conflicts
	with drivers/target/iscsi
Message-ID: <20110314145930.GB28480@lst.de>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org> <1300103829-10337-2-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300103829-10337-2-git-send-email-nab@linux-iscsi.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 04:56:58AM -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch renames the following iscsi_proto.h structures to avoid
> namespace issues with drivers/target/iscsi/iscsi_target_core.h:
> 
> *) struct iscsi_cmd -> struct iscsi_scsi_cmd

This name is not overly descriptive.  Using _req/_rsp uniformly would make a
lot more sense.

