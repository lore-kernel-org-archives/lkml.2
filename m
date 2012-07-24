Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2GXM2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 08:28:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab2GXM2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 08:28:36 -0400
Date: Tue, 24 Jul 2012 15:28:24 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com, penberg@kernel.org,
        asias.hejun@gmail.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        anthony@codemonkey.ws, wency@cn.fujitsu.com
Subject: Re: [RFC 0/2] virtio: provide a way for host to monitor critical
 events in the device
Message-ID: <20120724122824.GG26120@redhat.com>
References: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com>
 <20120724074434.GE26120@redhat.com>
 <500E9479.3050405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500E9479.3050405@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 02:26:33PM +0200, Sasha Levin wrote:
> On 07/24/2012 09:44 AM, Gleb Natapov wrote:
> > On Mon, Jul 23, 2012 at 10:32:39PM +0200, Sasha Levin wrote:
> >> As it was discussed recently, there's currently no way for the guest to notify
> >> the host about panics. Further more, there's no reasonable way to notify the
> >> host of other critical events such as an OOM kill.
> >>
> >> This short patch series introduces a new device named virtio-notifier which
> >> does two simple things:
> >>
> >>  1. Provide a simple interface for the guest to notify the host of critical
> > To get early OOPSes virtio will have to be compiled into the kernel. If
> > your are so keen on using virtio for this though, why not just use
> > dedicated virtio serial channel?
> 
> Let's separate between having log for these events and receiving notifications about them.
> 
> For the log part, I can already run a simple serial console to dump everything somewhere. I'm more concerned about having notifications about something critical happening when the guest is already up and running.
> 
I am talking about notifications. Run your notification protocol over
dedicated virtio-serial channel. Logs goes to virtio-console as you've
said.

--
			Gleb.
