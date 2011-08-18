Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab1HRSA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:00:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54954 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1HRSA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:00:26 -0400
Subject: Re: [PATCH] virtio-blk: Add stats VQ to collect information about
 devices
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4E4D4DAC.8080304@redhat.com>
References: <1313524071-27250-1-git-send-email-levinsasha928@gmail.com>
	 <4E4C481A.5080205@redhat.com> <1313642283.22532.4.camel@lappy>
	 <4E4D2B6D.1040908@redhat.com> <1313684984.30799.20.camel@lappy>
	 <4E4D4DAC.8080304@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 18 Aug 2011 20:59:13 +0300
Message-ID: <1313690353.30799.22.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 10:36 -0700, Avi Kivity wrote:
> On 08/18/2011 09:29 AM, Sasha Levin wrote:
> > >
> > >  What can you do with it?
> > >
> >
> > I was actually planning on submitting another patch that would add
> > something similar into virtio-net. My plan was to enable collecting
> > statistics regarding memory, network and disk usage in a simple manner
> > without accessing guests.
> >
> > How can this be used? my vision behind it was automation of kernel
> > testing and benchmarking.
> >
> 
> This is something that can be used by very few people, but everyone has 
> to carry it.  It's more efficient to add statistics support to your 
> automation framework (involving the guest).
> 

That was just one example of many possibilities. However, if you feel
this can't be used within monitoring or management platforms anyhow then
I'm ok with dropping it.

-- 

Sasha.

