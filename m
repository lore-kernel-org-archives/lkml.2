Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974Ab1EKRIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:08:13 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:41479 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1EKRIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:08:10 -0400
In-Reply-To: <cover.1304541918.git.mst@redhat.com>
References: <cover.1304541918.git.mst@redhat.com>
Subject: Re: [PATCH 00/18] virtio and vhost-net performance enhancements
X-KeepSent: 2BBEE530:9F02F495-6525788D:0057AC81;
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
Message-ID: <OF2BBEE530.9F02F495-ON6525788D.0057AC81-6525788D.005E1F24@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Wed, 11 May 2011 22:40:42 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 8.5.1FP5|September 29, 2010) at
 11/05/2011 22:40:51
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> wrote on 05/05/2011 02:20:18 AM:

> [PATCH 00/18] virtio and vhost-net performance enhancements
>
> OK, here's a large patchset that implements the virtio spec update that I
> sent earlier. It supercedes the PUBLISH_USED_IDX patches
> I sent out earlier.
>
> I know it's a lot to ask but please test, and please consider for
2.6.40 :)
>
> I see nice performance improvements: one run showed going from 12
> to 18 Gbit/s host to guest with netperf, but I did not spend a lot
> of time testing performance, so no guarantees it's not a fluke,
> I hope others will try this out and report.
> Pls note I will be away from keyboard for the next week.

I tested with the git tree (which also contains the later
additional patch), and get this error on guest:

May 11 08:06:08 localhost kernel: net eth0: Unexpected TX queue failure:
-28
May 11 08:06:08 localhost kernel: net eth0: Unexpected TX queue failure:
-28
May 11 08:06:08 localhost kernel: net eth0: Unexpected TX queue failure:
-28
May 11 08:06:08 localhost kernel: net eth0: Unexpected TX queue failure:
-28
...

The network stops after that and requires a modprobe "restart" to
get it working again. This is with the new qemu/vhost/virtio-net.

Please let me know if I am missing something.

thanks,

- KK

