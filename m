Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478Ab1ESSed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:34:33 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33251 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933829Ab1ESSe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=nc8ApmzuI4Dwwk/TTKrNjUvkAylLluCvKVtRIAZfVuAn+eYaPY5etBYJdXUDkIsqfZ
         djZJqliSmc304ONkSzsv/j/YbHedJSCejh+xuqsuJyZmOlv8c9NTzVlHZnbzlEtRjeuA
         If6jFROw2BP8AxjubxW8R7IYtkiNpMkuNJKjQ=
MIME-Version: 1.0
In-Reply-To: <20110519174420.GD12525@obsidianresearch.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com> <20110518170556.GB2595@obsidianresearch.com>
 <BANLkTikOCeNcDvoCM=BOSxQaSECFhJ05Gg@mail.gmail.com> <20110519174420.GD12525@obsidianresearch.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 19 May 2011 20:34:08 +0200
X-Google-Sender-Auth: pv21198uUGTazztIy5C1q8fJo7U
Message-ID: <BANLkTikOsqazAE-mHFrM+=4GTs+249Ae5Q@mail.gmail.com>
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

On Thu, May 19, 2011 at 7:44 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Thu, May 19, 2011 at 07:29:21PM +0200, Bart Van Assche wrote:
> > Regarding APM: the Linux kernel already has multipath support and
> > duplicate functionality is in general not welcomed. So you will have
> > to come up with a very good reason before APM support in ib_srp or
> > ib_srpt would be considered for acceptance.
>
> APM is a feature of IB's tranport layerthat provides disruption free
> lossless failover to a backup network path completely transparently to
> the application (eg SRP in this case).
>
> This plays a similar role in the IB stack to the realtime spanning
> tree protocol that ethernet uses, or the multipath IP routing that is
> already in the net stack. I don't see it duplicating SCSI multipath at
> all. On very large IB networks (eg > 1000 switches) the rate of link
> failures is high enough that taking an application level recovery on
> hundreds of nodes due to a link failure is troublesome.
>
> If ib_srpt is implemented properly it may already support APM because
> APM is supported by the IB CM that it relies on to setup connections,
> and any SRP client could already request APM functionality during
> connection setup.

My reply applies to your original statement where you were referring
to APM with different destination ports. What you write above is about
APM with identical destination ports and hence does not apply to my
reply.

Bart.
