Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966406Ab0CPOvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:51:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966284Ab0CPOvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:51:51 -0400
Date: Tue, 16 Mar 2010 16:48:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: locking issue in vhost_net_set_backend
Message-ID: <20100316144824.GA12793@redhat.com>
References: <4B9F8E7F.7070709@gmail.com> <4B9F8F4F.7010103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F8F4F.7010103@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 03:01:51PM +0100, Jiri Slaby wrote:
> On 03/16/2010 02:58 PM, Jiri Slaby wrote:
>> I don't see how the lock is unlocked on the error paths and as it is not
>> on none of the them maybe I'm missing something?
>
> And there is one more issue in vhost_set_vring, several returns from  
> VHOST_SET_VRING_KICK, VHOST_SET_VRING_CALL, VHOST_SET_VRING_ERR with the  
> vq->mutex held.

Thanks!
I have patches for these that I'll push out shortly.

> -- 
> js
