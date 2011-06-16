Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1FPOaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:30:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758252Ab1FPOaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:30:08 -0400
Date: Thu, 16 Jun 2011 17:28:59 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
Message-ID: <20110616142859.GA18356@redhat.com>
References: <1308153214.7566.6.camel@jaguar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1308153214.7566.6.camel@jaguar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 06:53:34PM +0300, Pekka Enberg wrote:
> Hi all,
> 
> We’re proud to announce the second version of the Native Linux KVM tool! We’re
> now officially aiming for merging to mainline in 3.1.
> 
> Highlights:
> 
> - Experimental GUI support using SDL and VNC
> 
> - SMP support. tools/kvm/ now has a highly scalable, largely lockless driver
>   interface and the individual drivers are using finegrained locks.
> 
> - TAP-based virtio networking

Wanted to ask for a while: would it make sense to use vhost-net?
Or maybe use that exclusively?
Less hypervisor code to support would help the focus.

-- 
MST
