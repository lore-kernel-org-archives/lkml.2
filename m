Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934Ab1FCEGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 00:06:07 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33751 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1FCEGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 00:06:03 -0400
In-Reply-To: <20110602153423.GA11300@redhat.com>
References: <cover.1306921434.git.mst@redhat.com> <1ec8eec325839ecf2eac9930a230361e7956047c.1306921434.git.mst@redhat.com> <87pqmwj3am.fsf@rustcorp.com.au> <20110602133425.GJ7141@redhat.com> <OF990F08C5.2ECE35B1-ON652578A3.004DC0FA-652578A3.004E3FE4@in.ibm.com> <20110602144346.GA7995@redhat.com> <OFFF109303.D838CAE2-ON652578A3.0053357D-652578A3.00549366@in.ibm.com> <20110602153423.GA11300@redhat.com>
Subject: Re: [PATCH RFC 3/3] virtio_net: limit xmit polling
X-KeepSent: B84D77BF:B23AE894-652578A4:00162627;
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
Message-ID: <OFB84D77BF.B23AE894-ON652578A4.00162627-652578A4.00168499@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Fri, 3 Jun 2011 09:38:52 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 8.5.1FP5|September 29, 2010) at
 03/06/2011 09:39:06
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> wrote on 06/02/2011 09:04:23 PM:

> > > Is this where the bug was?
> >
> > Return value in free_old_xmit() was wrong. I will re-do against the
> > mainline kernel.
> >
> > Thanks,
> >
> > - KK
>
> Just noting that I'm working on that patch as well, it might
> be more efficient if we don't both of us do this in parallel :)

OK, but my intention was to work on a alternate approach, which
was the reason to base it against your patch.

I will check your latest patch.

thanks,

- KK

