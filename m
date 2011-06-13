Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1FMNlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:41:03 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:40465 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab1FMNk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:40:58 -0400
In-Reply-To: <20110613133513.GA29884@redhat.com>
References: <cover.1307029008.git.mst@redhat.com> <20110607160830.GB17581@redhat.com> <OFE36F9C2B.43D9DB04-ON652578AE.0048E1AB-652578AE.004A1462@in.ibm.com> <20110613133513.GA29884@redhat.com>
Subject: Re: [PATCHv2 RFC 0/4] virtio and vhost-net capacity handling
X-KeepSent: F64BF5BD:B405A000-652578AE:004AE88C;
 type=4; name=$KeepSent
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>, habanero@linux.vnet.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux390@de.ibm.com,
        netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, steved@us.ibm.com,
        Tom Lendacky <tahm@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org, Shirley Ma <xma@us.ibm.com>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFF64BF5BD.B405A000-ON652578AE.004AE88C-652578AE.004B23D1@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Mon, 13 Jun 2011 19:14:07 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 8.5.1FP5|September 29, 2010) at
 13/06/2011 19:14:11
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> wrote on 06/13/2011 07:05:13 PM:

> > I ran the latest patches with 1K I/O (guest->local host) and
> > the results are (60 sec run for each test case):
>
> Hi!
> Did you apply this one:
> [PATCHv2 RFC 4/4] Revert "virtio: make add_buf return capacity remaining"
> ?
>
> It turns out that that patch has a bug and should be reverted,
> only patches 1-3 should be applied.
>
> Could you confirm please?

No, I didn't apply that patch. I had also seen your mail
earlier on this patch breaking receive buffer processing
if applied.

thanks,

- KK

