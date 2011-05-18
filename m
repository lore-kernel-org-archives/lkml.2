Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab1ERRGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:06:04 -0400
Received: from quartz.orcorp.ca ([139.142.54.143]:53190 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933231Ab1ERRGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:06:02 -0400
Date: Wed, 18 May 2011 11:05:56 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rmda <linux-rdma@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>, Vu Pham <vu@mellanox.com>,
        David Dillow <dillowda@ornl.gov>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt
 merge
Message-ID: <20110518170556.GB2595@obsidianresearch.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 06:59:36PM +0200, Bart Van Assche wrote:

> As far as I know InfiniBand HCAs have either one or two ports. If
> there are two ports present, at most one is active at any time.

This is not true, many installations run dual rail IB with a desire
for both ports to be active and handling traffic at once. Not sure how
this translates to SRPT, but a good goal would be for a SRPT target to
be available on both HCA ports and support APM between them, at the
discretion of the client.

Jason
