Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab1ERSDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:03:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41546 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab1ERSDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=P2/o+JAkmqHcf0KxoT+zxivu9zYchx/EMYzQ6AWe2NKZQrjwlCNy5fqYKu9zkE8kbb
         xJXsRHGHvwebRV0Y9OUmRIABuzFT3LmRy1ria0w/49MwY3BBalmzXXK0NwDrPJS/jZy5
         3tTJqJ9EsoEuaeJBsAR2dQrd1g6il+rFnFR/c=
MIME-Version: 1.0
In-Reply-To: <20110518170556.GB2595@obsidianresearch.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com> <20110518170556.GB2595@obsidianresearch.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 18 May 2011 20:02:51 +0200
X-Google-Sender-Auth: L27obKrYvfWsvtxBYDuGCm0RBkM
Message-ID: <BANLkTimQXU0u5gtRzXsnsB=sCF-bvpY+Ag@mail.gmail.com>
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
> On Wed, May 18, 2011 at 06:59:36PM +0200, Bart Van Assche wrote:
>
>> As far as I know InfiniBand HCAs have either one or two ports. If
>> there are two ports present, at most one is active at any time.
>
> This is not true, many installations run dual rail IB with a desire
> for both ports to be active and handling traffic at once. Not sure how
> this translates to SRPT, but a good goal would be for a SRPT target to
> be available on both HCA ports and support APM between them, at the
> discretion of the client.

Thanks for the feedback. I'm still wondering though about the
usefulness of disabling / enabling SRPT per HCA port. For the use
cases I know about SRP communication over all target ports will be
enabled as soon as target configuration has finished and more
fine-grained access configuration will occur by allowing/disallowing
certain initiators to log in.

Bart.
