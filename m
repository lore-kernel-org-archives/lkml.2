Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab1ELO3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:29:42 -0400
Received: from 8bytes.org ([88.198.83.132]:33084 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486Ab1ELO3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:29:41 -0400
Date: Thu, 12 May 2011 16:29:40 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
Message-ID: <20110512142940.GJ8707@8bytes.org>
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org> <4DCBAD8F.8030006@redhat.com> <20110512130644.GF8707@8bytes.org> <4DCBE2C9.20709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCBE2C9.20709@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 04:38:17PM +0300, Avi Kivity wrote:
> On 05/12/2011 04:06 PM, Joerg Roedel wrote:

>> AMD processors don't implement that cpuid leaf.
>
> Right.  But if an AMD processor were to implement that leaf, it would be  
> in a compatible manner, yes?

No official statement, but I guess this is the case. I have to check
back, though.

> A paravirt PMU also has to be implemented on top of perf_events.   
> Otherwise we can't share this resource.  So the only question is what  
> the interface looks like.  The arch pmu is non-optimized, but well  
> specified and somewhat supported in guests.  A paravirt pmu is not so  
> well specified at this point but can be faster (less exits).

I agree that getting the interface right is certainly the most difficult
and important task here.

	Joerg

