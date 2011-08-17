Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1HQXAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 19:00:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab1HQXAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 19:00:53 -0400
Message-ID: <4E4C481A.5080205@redhat.com>
Date: Wed, 17 Aug 2011 16:00:42 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: Add stats VQ to collect information about
 devices
References: <1313524071-27250-1-git-send-email-levinsasha928@gmail.com>
In-Reply-To: <1313524071-27250-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2011 12:47 PM, Sasha Levin wrote:
> This patch adds support for an optional stats vq that works similary to the
> stats vq provided by virtio-balloon.
>
> The purpose of this change is to allow collection of statistics about working
> virtio-blk devices to easily analyze performance without having to tap into
> the guest.
>
>

Why can't you get the same info from the host?  i.e. read sectors?

Patches to virtio drivers should be preceded by specification updates so 
that guest driver authors and alternative userspace developers have a 
solid reference.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

