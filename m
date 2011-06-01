Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab1FAMPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:15:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56302 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1FAMPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:15:46 -0400
X-Greylist: delayed 3069 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jun 2011 08:15:46 EDT
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <4DE60A34.7070603@redhat.com>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
	 <4DD24544.1000408@redhat.com>  <4DE60A34.7070603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Jun 2011 12:26:32 +0200
Message-ID: <1306923992.2353.165.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 12:45 +0300, Avi Kivity wrote:
> On 05/17/2011 12:52 PM, Avi Kivity wrote:
> > On 05/11/2011 06:55 PM, Avi Kivity wrote:
> >> perf maintainers: please consider the first three patches for merging 
> >> (the
> >> first two make sense even without the rest).  If you're familiar with 
> >> the Intel
> >> PMU, please review patch 5 as well - it effectively undoes all your work
> >> of abstracting the PMU into perf_events by unabstracting perf_events 
> >> into what
> >> is hoped is a very similar PMU.
> >
> > Perf maintainers, ping?
> >
> 
> Re-ping?

Still struggling with merge window fallout, this is soon after that.
