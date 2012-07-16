Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2GPJDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:03:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab2GPJDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:03:25 -0400
Message-ID: <5003D93E.2000304@redhat.com>
Date: Mon, 16 Jul 2012 17:05:02 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jeff Moyer <jmoyer@redhat.com>, kvm@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@redhat.com>
Subject: Re: [PATCH RESEND 0/5] Add vhost-blk support
References: <1342169711-12386-1-git-send-email-asias@redhat.com> <20120714074911.GA31684@infradead.org>
In-Reply-To: <20120714074911.GA31684@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 07/14/2012 03:49 PM, Christoph Hellwig wrote:
> Please send a version that does direct block I/O similar to xen-blkback
> for now.

Seems xen-blkback converts the guest IO request to host bio and submit 
them directly. I was wondering whether this has a performance gain 
compared to AIO implementation.

> If we get proper in-kernel aio support one day you can add
> back file backend support.

I talked with Dave and Zack on the in-kernel aio patch which James 
pointed out:

http://marc.info/?l=linux-fsdevel&m=133312234313122

Dave will post a new version soon. I will wait for it.

-- 
Asias


