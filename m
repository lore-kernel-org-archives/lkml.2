Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab1HRSbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:31:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1HRSbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:31:42 -0400
Message-ID: <4E4D5A57.6070600@redhat.com>
Date: Thu, 18 Aug 2011 11:30:47 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] virtio-blk: Add stats VQ to collect information about
 devices
References: <1313524071-27250-1-git-send-email-levinsasha928@gmail.com>  <4E4C481A.5080205@redhat.com> <1313642283.22532.4.camel@lappy>  <4E4D2B6D.1040908@redhat.com> <1313684984.30799.20.camel@lappy>  <4E4D4DAC.8080304@redhat.com> <1313690353.30799.22.camel@lappy>
In-Reply-To: <1313690353.30799.22.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 10:59 AM, Sasha Levin wrote:
> >
> >  This is something that can be used by very few people, but everyone has
> >  to carry it.  It's more efficient to add statistics support to your
> >  automation framework (involving the guest).
> >
>
> That was just one example of many possibilities. However, if you feel
> this can't be used within monitoring or management platforms anyhow then
> I'm ok with dropping it.
>

It really depends on the possibilities.

Adding features is fine, but we need to know they'll be useful to many 
people.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

