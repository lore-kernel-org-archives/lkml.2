Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab1ERL5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:57:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52480 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873Ab1ERL5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:57:47 -0400
Date: Wed, 18 May 2011 13:57:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 5/5] KVM: Expose a version 1 architectural PMU to
 guests
Message-ID: <20110518115739.GA6210@elte.hu>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
 <1305129333-7456-6-git-send-email-avi@redhat.com>
 <20110517194117.GA26184@elte.hu>
 <4DD38B57.2070904@redhat.com>
 <20110518110759.GB16556@elte.hu>
 <1305718188.2466.7104.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305718188.2466.7104.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2011-05-18 at 13:07 +0200, Ingo Molnar wrote:
> > 
> > Peter, what do you think about adding a inv and cmask attribute that is applied 
> > to generic events automatically? 
> 
> Have you read the PPC, ARM and SPARC64 PMU definition to check if that makes 
> sense?

No - some feedback from them would be nice.

Thanks,

	Ingo
