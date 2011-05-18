Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab1ERQqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:46:42 -0400
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:60453 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932910Ab1ERQql convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:46:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110518074716.GA8927@infradead.org>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org> <20110518074716.GA8927@infradead.org>
From: Roland Dreier <roland@purestorage.com>
Date: Wed, 18 May 2011 09:46:20 -0700
Message-ID: <BANLkTinMpr=srhHim5G9e8NkB9BG2ctNdA@mail.gmail.com>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt merge
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rmda <linux-rdma@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, Vu Pham <vu@mellanox.com>,
        David Dillow <dillowda@ornl.gov>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We really need to stop spreading that include.  Care to submit a patch
> for .40 to move the TASK_ATTR_* defines to scsi/scsi.h?

Sounds simple enough even for me to do.  I'll send one in a little bit...

 - R.
