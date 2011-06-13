Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1FMNfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:35:46 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:41337 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab1FMNfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:35:42 -0400
In-Reply-To: <OFE36F9C2B.43D9DB04-ON652578AE.0048E1AB-652578AE.004A1462@in.ibm.com>
References: <cover.1307029008.git.mst@redhat.com> <20110607160830.GB17581@redhat.com> <OFE36F9C2B.43D9DB04-ON652578AE.0048E1AB-652578AE.004A1462@in.ibm.com>
Subject: Re: [PATCHv2 RFC 0/4] virtio and vhost-net capacity handling
X-KeepSent: A835D731:5CFF0BC8-652578AE:004A7516;
 type=4; name=$KeepSent
To: Krishna Kumar2 <krkumar2@in.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>, habanero@linux.vnet.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux390@de.ibm.com,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        netdev-owner@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, steved@us.ibm.com,
        Tom Lendacky <tahm@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org, Shirley Ma <xma@us.ibm.com>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFA835D731.5CFF0BC8-ON652578AE.004A7516-652578AE.004AAAA8@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Mon, 13 Jun 2011 19:08:51 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 8.5.1FP5|September 29, 2010) at
 13/06/2011 19:08:52
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Krishna Kumar2/India/IBM@IBMIN wrote on 06/13/2011 07:02:27 PM:

...

> With 16K, there was an improvement in SD, but
> higher sessions seem to slightly degrade BW/SD:

I meant to say "With 16K, there was an improvement in BW"
above. Again the numbers are not very reproducible,
I will test with remote host also to see if I get more
consistent numbers.

Thanks,

- KK

>
> ______________________________
> #sessions  BW%      SD%
> ______________________________
> 1          30.9    -25.0
> 2          16.5    -19.4
> 4         -1.3      7.9
> 8          1.4      6.2
> 16         3.9     -5.4
> 32         0        4.3
> 48        -.5        .1
> 64         32.1    -1.5
> 96        -2.1      23.2
> 128       -7.4      3.8
> ______________________________
> BW: 5.0          SD: 7.5

