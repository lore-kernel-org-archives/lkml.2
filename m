Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2EJGCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 02:02:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab2EJGCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 02:02:34 -0400
Date: Thu, 10 May 2012 09:02:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [RFC PATCH] virtio_console: link vq to port with a private
 pointer in struct virtqueue
Message-ID: <20120510060232.GB23665@redhat.com>
References: <87397be80k.fsf@rustcorp.com.au>
 <1336470355-19257-1-git-send-email-pbonzini@redhat.com>
 <20120508101839.GA15598@redhat.com>
 <877gwkddxq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gwkddxq.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:56:09AM +0930, Rusty Russell wrote:
> I think that making vring_virtqueue public looks like the way to go,
> too.

Then it's easy: transports can include vring_virtqueue
at end of transport structure.
