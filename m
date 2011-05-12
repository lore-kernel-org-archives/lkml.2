Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab1ELNLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:11:32 -0400
Received: from 8bytes.org ([88.198.83.132]:48709 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab1ELNLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:11:31 -0400
Date: Thu, 12 May 2011 15:11:30 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
Message-ID: <20110512131130.GG8707@8bytes.org>
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org> <4DCBACC7.8080000@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCBACC7.8080000@siemens.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:47:51AM +0200, Jan Kiszka wrote:
> On 2011-05-12 11:33, Joerg Roedel wrote:

> > Anyway, I thought about a paravirt-approach instead of implementing a
> > real PMU... But there are certainly good reasons for both.
> 
> Paravirt is taking away the pressure from CPU vendors to do their virt
> extensions properly - and doesn't help with unmodifiable OSes.

Seriously, I think such decisions should be technical only and not
political like that. The losers of such political decisions are always
the users because they don't get useful features that are technical
possible.

Regards,

	Joerg

