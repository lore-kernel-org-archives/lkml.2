Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab1EKQmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:42:53 -0400
Received: from 8bytes.org ([88.198.83.132]:54293 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab1EKQmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:42:51 -0400
Date: Wed, 11 May 2011 10:57:44 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/3] perf support for amd guest/host-only bits
Message-ID: <20110511085744.GA8707@8bytes.org>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com> <20110510152132.GA25705@elte.hu> <20110510155024.GG30996@amd.com> <20110510204149.GE21903@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510204149.GE21903@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 10:41:49PM +0200, Ingo Molnar wrote:

> 'perf kvm' is the tool that is making Linux instrumentation friendlier to KVM 
> developers. Can you think of ways to utilize this new feature there?
> 
> For example a new 'perf kvm stat' feature could pass the exclusion bits to perf 
> stat automatically. 'perf kvm record' could record on the guest only by 
> default.

Yes, that would make sense. 'perf kvm' can default to guest-only
profiling. Hmm, but that would change existing behavior. It is probably
better to bind it to the --guest and --host parameters of perf-kvm.
Okay, this changes existing behavior too, so the default-thing seems the
better choice :)

	Joerg

