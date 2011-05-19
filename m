Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab1ESR3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:29:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45234 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933596Ab1ESR3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=gIYUzFTqHASK+beenj5eCN6rGJrrjPESXytL29jMCk3Kx2cK4QNYWes4ETCjCjk5Dx
         sdqX+XY8meq2kT/jc5rDQnDVA+5C6WTGjmXvtWPcAGiZ8mHoLLr7iE9WhuB5OwSc1L3z
         VfMT4YBSQeKC5P1wUHLTLN6Kkgx/KobJK0FZ0=
MIME-Version: 1.0
In-Reply-To: <20110518170556.GB2595@obsidianresearch.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com> <20110518170556.GB2595@obsidianresearch.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 19 May 2011 19:29:21 +0200
X-Google-Sender-Auth: PIwcjBHZfgz1uN9ItbCb9wlOcl4
Message-ID: <BANLkTikOCeNcDvoCM=BOSxQaSECFhJ05Gg@mail.gmail.com>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt merge
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rmda <linux-rdma@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>, Vu Pham <vu@mellanox.com>,
        David Dillow <dillowda@ornl.gov>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 7:05 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> Many installations run dual rail IB with a desire
> for both ports to be active and handling traffic at once. Not sure how
> this translates to SRPT, but a good goal would be for a SRPT target to
> be available on both HCA ports and support APM between them, at the
> discretion of the client.

Regarding APM: the Linux kernel already has multipath support and
duplicate functionality is in general not welcomed. So you will have
to come up with a very good reason before APM support in ib_srp or
ib_srpt would be considered for acceptance.

Bart.
