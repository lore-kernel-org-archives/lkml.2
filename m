Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab0EZJVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:21:50 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59518 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab0EZJVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:21:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FxEaGpiCKwO6WCUqpnlnV3NIFgbs9Ga17205yv9Oe8TEEzGXB5viVEOSgDP06CkD9
	3XcMTCf6jSjzJ3Z1PLoFQ==
Date: Wed, 26 May 2010 02:21:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
cc: Catalin Marinas <catalin.marinas@arm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       Jerome Glisse <glisse@freedesktop.org>
Subject: Re: 2.6.33.2 kmalloc-8 slab leaks ~512 objects per second
In-Reply-To: <201005131339.32113.tvrtko.ursulin@sophos.com>
Message-ID: <alpine.DEB.2.00.1005260220460.8417@chino.kir.corp.google.com>
References: <201005121121.49135.tvrtko.ursulin@sophos.com> <201005121404.49720.tvrtko.ursulin@sophos.com> <tnxiq6sm1c2.fsf@e102109-lin.cambridge.arm.com> <201005131339.32113.tvrtko.ursulin@sophos.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010, Tvrtko Ursulin wrote:

> > You could just enable CONFIG_DEBUG_KMEMLEAK on 2.6.33, mount the debugfs
> > and do a 'cat /sys/kernel/debug/kmemleak' after a half-hour or so.
> 
> I could do it if radeon/drm guys would be interested in those results? (Given
> how 2.6.34-rc7 is not leaking.)
> 

Did you get a chance to find out if kmemleak was able to identify the 
source of this problem?
