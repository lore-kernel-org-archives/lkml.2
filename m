Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab1EZQSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:18:44 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57438 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1EZQSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:18:42 -0400
In-Reply-To: <OFE30C8D78.526FF88D-ON8725789C.00563B8C-8825789C.0056469F@us.ibm.com>
References: <cover.1305846412.git.mst@redhat.com> <OF0EFA7BA9.BB2C2860-ON6525789C.0053EE3A-6525789C.005513CC@in.ibm.com> <OFE30C8D78.526FF88D-ON8725789C.00563B8C-8825789C.0056469F@us.ibm.com>
Subject: Re: [PERF RESULTS] virtio and vhost-net performance enhancements
X-KeepSent: F9D0E604:B865A006-6525789C:00597010;
 type=4; name=$KeepSent
To: Shirley Ma <xma@us.ibm.com>
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
        virtualization@lists.linux-foundation.org
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFF9D0E604.B865A006-ON6525789C.00597010-6525789C.0059987A@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Thu, 26 May 2011 21:51:32 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 8.5.1FP5|September 29, 2010) at
 26/05/2011 21:51:38
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shirley Ma <xma@us.ibm.com> wrote on 05/26/2011 09:12:22 PM:

> Could you please try TCP_RRs as well?

Right. Here's the result for TCP_RR:

__________________________________
#       RR%     SD%     CPU%
__________________________________
1       4.5       -31.4    -27.9
2       5.1       -9.7      -5.4
4       60.4     -13.4     38.8
8       67.8     -13.5     45.0
16     55.8     -8.0       43.2
32     66.9     -14.1     43.3
64     47.2     -23.7     12.2
96     29.7     -11.8     14.3
128    8.0       2.2       10.7
___________________________________
BW: 37.3%   SD: -6.7%   CPU: 15.7%
___________________________________

Thanks,

- KK

