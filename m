Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab1EZQ0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:26:23 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49850 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab1EZQ0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:26:20 -0400
In-Reply-To: <OFF9D0E604.B865A006-ON6525789C.00597010-6525789C.0059987A@LocalDomain>
References: <cover.1305846412.git.mst@redhat.com> <OF0EFA7BA9.BB2C2860-ON6525789C.0053EE3A-6525789C.005513CC@in.ibm.com> <OFE30C8D78.526FF88D-ON8725789C.00563B8C-8825789C.0056469F@us.ibm.com> <OFF9D0E604.B865A006-ON6525789C.00597010-6525789C.0059987A@LocalDomain>
Subject: Re: [PERF RESULTS] virtio and vhost-net performance enhancements
X-KeepSent: 75734CC8:5E488020-6525789C:005A0CF6;
 type=4; name=$KeepSent
To: Krishna Kumar2 <krkumar2@in.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>, habanero@linux.vnet.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux390@de.ibm.com,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steve Dobbelstein <steved@us.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org, Shirley Ma <xma@us.ibm.com>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OF75734CC8.5E488020-ON6525789C.005A0CF6-6525789C.005A4B7B@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Thu, 26 May 2011 21:59:10 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 8.5.1FP5|September 29, 2010) at
 26/05/2011 21:59:17
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krishna Kumar2/India/IBM wrote on 05/26/2011 09:51:32 PM:

> > Could you please try TCP_RRs as well?
>
> Right. Here's the result for TCP_RR:

The actual transaction rate/second numbers are:

_____________________________________________________________
#     RR1      RR2 (%)          SD1        SD2 (%)
_____________________________________________________________
1     9476     9903 (4.5)       28.9       19.8 (-31.4)
2     17337    18225 (5.1)      92.7       83.7 (-9.7)
4     17385    27902 (60.4)     364.8      315.8 (-13.4)
8     25560    42912 (67.8)     1428.1     1234.0 (-13.5)
16    35898    55934 (55.8)     4391.6     4038.1 (-8.0)
32    48048    80228 (66.9)     17391.4    14932.0 (-14.1)
64    60412    88929 (47.2)     71087.7    54230.1 (-23.7)
96    71263    92439 (29.7)     145434.1   128214.0 (-11.8)
128   84208    91014 (8.0)      233668.2   238888.6 (2.2)
_____________________________________________________________
RR: 37.3%     SD: -6.7%
_____________________________________________________________

Thanks,

- KK

