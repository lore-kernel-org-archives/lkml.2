Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab1CNVsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:48:02 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:44164 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab1CNVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:48:00 -0400
Subject: Re: [RFC-v2 01/12] iscsi: Resolve iscsi_proto.h naming conflicts
	with drivers/target/iscsi
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Open iSCSI <open-iscsi@googlegroups.com>
In-Reply-To: <20110314145930.GB28480@lst.de>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
	 <1300103829-10337-2-git-send-email-nab@linux-iscsi.org>
	 <20110314145930.GB28480@lst.de>
Content-Type: text/plain
Date: Mon, 14 Mar 2011 14:40:56 -0700
Message-Id: <1300138856.28255.133.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 15:59 +0100, Christoph Hellwig wrote:
> On Mon, Mar 14, 2011 at 04:56:58AM -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch renames the following iscsi_proto.h structures to avoid
> > namespace issues with drivers/target/iscsi/iscsi_target_core.h:
> > 
> > *) struct iscsi_cmd -> struct iscsi_scsi_cmd
> 
> This name is not overly descriptive.  Using _req/_rsp uniformly would make a
> lot more sense.
> 

Mmmm, fair point here..  I don't have a strong preference so I will
defer to Mike and Hannes on this (open-iscsi CC'ed).  Guys is this OK
with you..?

Thanks,

--nab

