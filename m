Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1EKRXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:23:15 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:59522 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1EKRXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:23:12 -0400
Date: Wed, 11 May 2011 16:02:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Joerg Roedel <joerg.roedel@amd.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, core: Introduce attrs to count in either host
 or guest mode
Message-ID: <20110511140242.GB18219@elte.hu>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
 <1305038132-5080-2-git-send-email-joerg.roedel@amd.com>
 <4DCA76A5.7030000@redhat.com>
 <4DCA76D7.2010608@redhat.com>
 <1305121745.2914.216.camel@laptop>
 <4DCA94B7.7090001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCA94B7.7090001@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> On 05/11/2011 04:49 PM, Peter Zijlstra wrote:
> >On Wed, 2011-05-11 at 14:45 +0300, Avi Kivity wrote:
> >>  Well, actually, that depends on the meaning of exclude_hv.
> >
> >exclude_hv is for when the host is a guest and we don't wish to sample
> >the host's host etc. PPC introduced this because ppc-linux runs as a
> >guest of the 'firmware' and not on the native hardware.
> 
> Okay.  A comment is needed there to explain the differences then.

Yeah.

Also, the flags are named in a way to make the default zero value the most 
inclusive option. So we do not have include_guest but exclude_guest, etc.

Thanks,

	Ingo
