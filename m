Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab0IHCnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:43:00 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:59633 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab0IHCm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:42:56 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [RFC 06/22] tcm: Add ConfigFS subsystem backstore infrastructure
Date: Tue, 7 Sep 2010 22:41:23 -0400
User-Agent: KMail/1.9.10
Cc: "linux-scsi" <linux-scsi@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
References: <1283160058-6674-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1283160058-6674-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009072241.25115.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 August 2010 05:20:58 Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds the TCM/ConfigFS core HBA and device backstore
> infrastructre objects in /sys/kernel/config/target/core.  It includes
> wrappers to logic for Persistent Reservations and ALUA, and supports
> Linux/SCSI, Linux/BLOCK, and Linux/FILEIO backstores using TCM subsystem
> plugin API.
>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_configfs.c | 3334

Considering this is in configfs, you should copy  Joel on this. I added him on 
the huge CC-list.

The only comments I've about this file is the majority of the printk should be 
KERN_DEBUG and that the EXPORT_SYMBOL should be EXPORT_SYMBOL_GPL.
