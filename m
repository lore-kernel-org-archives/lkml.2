Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab1GCQgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 12:36:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015Ab1GCQgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 12:36:45 -0400
Date: Sun, 3 Jul 2011 19:36:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        dave@linux.vnet.ibm.com, Amit Shah <amit.shah@redhat.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] virtio_balloon: Notify guest only after deflating the
 balloon
Message-ID: <20110703163653.GA25750@redhat.com>
References: <1309576016-22800-1-git-send-email-levinsasha928@gmail.com>
 <20110703082748.GD13183@redhat.com>
 <1309686419.2250.8.camel@sasha>
 <20110703103051.GA15537@redhat.com>
 <1309690349.2250.21.camel@sasha>
 <20110703121137.GA15826@redhat.com>
 <1309696356.2250.31.camel@sasha>
 <20110703134439.GA22493@redhat.com>
 <1309705961.2250.36.camel@sasha>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309705961.2250.36.camel@sasha>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 06:12:41PM +0300, Sasha Levin wrote:
> If we choose to
> leave it this way we can just go ahead and remove MUST_TELL_HOST.

It probably needs to stay so that the host can detect that
the guest does guarantee telling it first.
-- 
MST
