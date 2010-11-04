Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0KDVha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 17:37:30 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36234 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab0KDVh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 17:37:29 -0400
Subject: Re: [RFC PATCH 1/1] vhost: TX used buffer guest signal accumulation
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101104093045.GA27506@redhat.com>
References: <1288216693.17571.38.camel@localhost.localdomain>
	 <1288240804.14342.1.camel@localhost.localdomain>
	 <20101028052021.GD5599@redhat.com>
	 <1288286062.11251.15.camel@localhost.localdomain>
	 <20101029081027.GB22688@redhat.com>
	 <1288366988.4110.5.camel@localhost.localdomain>
	 <20101030200603.GA19033@redhat.com>
	 <1288642673.19173.8.camel@localhost.localdomain>
	 <20101103104812.GB10555@redhat.com>
	 <1288849126.12932.4.camel@localhost.localdomain>
	 <20101104093045.GA27506@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 14:37:23 -0700
Message-ID: <1288906643.16508.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 11:30 +0200, Michael S. Tsirkin wrote:
> One thing to note is that deferred signalling needs to be
> benchmarked with old guests which don't orphan skbs on xmit
> (or disable orphaning in both networking stack and virtio-net).

Yes, we need run more test.

> 
> OK, so I guess I'll queue the __put_user etc patches for net-next, on
> top of this
> I think a patch which defers signalling would be nice to have,
> then we can figure out whether a separate heads array still has
> benefits
> for non zero copy case: if yes what they are, if no whether it should
> be
> used for zero copy only for both both non-zero copy and zero copy.
> 
> Makes sense? 

Agree.

Shirley

