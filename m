Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab1CRWTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:19:51 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:55304 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837Ab1CRWTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:19:45 -0400
Subject: Re: [PATCH] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20110318140924.GA29373@lst.de>
References: <1300396040-24253-1-git-send-email-nab@linux-iscsi.org>
	 <20110318140924.GA29373@lst.de>
Content-Type: text/plain
Date: Fri, 18 Mar 2011 15:12:41 -0700
Message-Id: <1300486361.20672.51.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 15:09 +0100, Christoph Hellwig wrote:
> Now that everything is in one C file all functions can be marked static,
> and there is no need to have prototypes in the header file.
> 

Ugh sorry, this had skipped my mind before posting yesterday, and has
since been fixed up in lio-4.1.  I will send out a updated PATCH-v2
shortly.

Thanks,

--nab


