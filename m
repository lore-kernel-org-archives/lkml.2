Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab2EDRx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:53:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54755 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab2EDRx5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:53:57 -0400
Message-ID: <1336154008.6509.48.camel@twins>
Subject: Re: [PATCH v2] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 04 May 2012 19:53:28 +0200
In-Reply-To: <1335957283.13683.180.camel@twins>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
	 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
	 <20120502103309.GP18810@erda.amd.com> <1335957283.13683.180.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 13:14 +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-02 at 12:33 +0200, Robert Richter wrote:
> > Updated version. Level 1 and 2 are handled the same way now. Don't
> > drop samples in precise level 2 if rip is invalid, instead support the
> > PERF_EFLAGS_EXACT flag.
> > 
> > No changes in other patches of
> > 
> >  [PATCH 00/12] perf/x86-ibs: Precise event sampling with IBS for AMD CPUs
> 
> Thanks!, I managed to stomp all patches on top of -tip and shall be
> trying it out on my aging opteron-1216.

Hmm, that box isn't reporting X86_FEATURE_IBS, a quick trip to Wikipedia
tells me this is a K8 (Santa Ana), not Fam 10h. Means I don't actually
have any hardware to test this on :-(

I'll have to throw it to Ingo then, IIRC he's got an Istanbul part.
