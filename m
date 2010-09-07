Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab0IGV1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:27:18 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:53277 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757753Ab0IGV1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:27:15 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 02/22] configfs: Add struct configfs_item_operations->check_link() in configfs_unlink()
Date: Tue, 7 Sep 2010 17:01:01 -0400
User-Agent: KMail/1.9.10
Cc: Joel Becker <Joel.Becker@oracle.com>,
        "linux-scsi" <linux-scsi@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>,
        "Linux-fsdevel" <linux-fsdevel@vger.kernel.org>
References: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org> <20100902064814.GB27904@mail.oracle.com> <1283456440.5598.108.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1283456440.5598.108.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009071701.02847.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	I NAK'd this a while back.  I'm willing to be convinced, but so
> > far it remains that way.
>
> Hi Joel,
>
> Thanks for bringing this point up again.  So a brief refresh on why this
> is currently required in the fabric independent configfs handlers in
> drivers/target/target_core_fabric_configfs.c (patch #19).

Well, that is great that you mentioned your requirements. But I don't see a 
quote of Joel's concerns? Is there an LKML link for it perhaps?
