Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1LDRhW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 12:37:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab1LDRhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 12:37:20 -0500
Message-ID: <4EDBAFC5.2010405@redhat.com>
Date: Sun, 04 Dec 2011 19:37:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect
 descriptors
References: <4ED4F30F.8000603@redhat.com> <1322669511.3985.8.camel@lappy>  <87wrahrp0u.fsf@rustcorp.com.au> <20111201075847.GA5479@redhat.com>  <1322726977.3259.3.camel@lappy> <20111201102640.GB8822@redhat.com>  <87zkfbre9x.fsf@rustcorp.com.au> <1322913028.3782.4.camel@lappy>  <4EDB5EF0.2010909@redhat.com> <1323000831.4205.4.camel@lappy>  <20111204162221.GB22501@redhat.com> <1323020088.3256.3.camel@lappy>
In-Reply-To: <1323020088.3256.3.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2011 07:34 PM, Sasha Levin wrote:
> > 
> > I'm confused. didn't you see a bigger benefit for guest->host by
> > switching indirect off?
>
> The 5% improvement is over the 'regular' indirect on, not over indirect
> off. Sorry for the confusion there.
>
> I suggested this change regardless of the outcome of indirect descriptor
> threshold discussion, since it would help anyways.

For net, this makes sense.  For block, it reduces the effective queue
depth, so it's not a trivial change.  It probably makes sense there too,
though.

-- 
error compiling committee.c: too many arguments to function

