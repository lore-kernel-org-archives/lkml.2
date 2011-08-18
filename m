Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab1HRRhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:37:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab1HRRhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:37:22 -0400
Message-ID: <4E4D4DAC.8080304@redhat.com>
Date: Thu, 18 Aug 2011 10:36:44 -0700
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
References: <1313524071-27250-1-git-send-email-levinsasha928@gmail.com>  <4E4C481A.5080205@redhat.com> <1313642283.22532.4.camel@lappy>  <4E4D2B6D.1040908@redhat.com> <1313684984.30799.20.camel@lappy>
In-Reply-To: <1313684984.30799.20.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 09:29 AM, Sasha Levin wrote:
> >
> >  What can you do with it?
> >
>
> I was actually planning on submitting another patch that would add
> something similar into virtio-net. My plan was to enable collecting
> statistics regarding memory, network and disk usage in a simple manner
> without accessing guests.
>
> How can this be used? my vision behind it was automation of kernel
> testing and benchmarking.
>

This is something that can be used by very few people, but everyone has 
to carry it.  It's more efficient to add statistics support to your 
automation framework (involving the guest).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

