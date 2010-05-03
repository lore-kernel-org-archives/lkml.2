Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab0ECJgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:36:09 -0400
Received: from ozlabs.org ([203.10.76.45]:48435 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab0ECJgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:36:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 2/2] virtio-net: pass gfp to add_buf
Date: Mon, 3 May 2010 19:05:56 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Amit Shah <amit.shah@redhat.com>, Mark McLoughlin <markmc@redhat.com>,
       Tejun Heo <tj@kernel.org>, Eric Van Hensbergen <ericvh@gmail.com>,
       Shirley Ma <xma@us.ibm.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
References: <cover.1272549641.git.mst@redhat.com> <c84e32efa3a2ce67f8b416374af0f2ea2926e230.1272549642.git.mst@redhat.com>
In-Reply-To: <c84e32efa3a2ce67f8b416374af0f2ea2926e230.1272549642.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005031905.58396.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010 11:56:42 pm Michael S. Tsirkin wrote:
> virtio-net bounces buffer allocations off to
> a thread if it can't allocate buffers from the atomic
> pool. However, if posting buffers still requires atomic
> buffers, this is unlikely to succeed.
> Fix by passing in the proper gfp_t parameter.

Thanks, applied with the predecessor.

Cheers,
Rusty.
