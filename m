Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab2ECLIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:08:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756994Ab2ECLIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:08:44 -0400
Date: Thu, 3 May 2012 14:08:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] virtio-net: remove useless disable on freeze
Message-ID: <20120503110845.GA25569@redhat.com>
References: <20120404091954.GA3776@redhat.com>
 <20120503105959.GM13421@amit.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503105959.GM13421@amit.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 04:29:59PM +0530, Amit Shah wrote:
> On (Wed) 04 Apr 2012 [12:19:55], Michael S. Tsirkin wrote:
> > disable_cb is just an optimization: it
> > can not guarantee that there are no callbacks.
> 
> Even then, what's the harm in keeping it?  If indeed there's an
> attempt to raise an interrupt after the host has been notified, it
> will be suppressed.

It won't. It's not a guarantee, e.g. with event index on
it does nothing at all.

> Also, disable_cb seems to be used elsewhere in the virtio_net.c file,
> to suit similar purposes.
> 
> 		Amit

Where?
