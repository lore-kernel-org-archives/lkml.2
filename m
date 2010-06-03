Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0FCMmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:42:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35748 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0FCMmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R2cunvxYJRF/eRQicFlEHtMcoSZwVOq3lnCjozoeolhCTNq4Qon+pXndXIWljwryR+
         hK3i88PS0k5l8qDaOh6Pj1Ko0oFSg1k9EzGDZgeT0hFSDSmjOYR++NYLHoWVvJJ2O9qa
         Ezy9i5d1W8hLkwlV7YRIkseLnmV1WhYNja1PQ=
Date: Thu, 3 Jun 2010 14:42:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf crash fix
Message-ID: <20100603124219.GB5234@nowhere>
References: <1275534810-1837-1-git-send-regression-fweisbec@gmail.com> <1275552159.27810.34944.camel@twins> <20100603123543.GA5234@nowhere> <1275568831.27810.35654.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275568831.27810.35654.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 02:40:31PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-03 at 14:35 +0200, Frederic Weisbecker wrote:
> 
> > I wanted to, but I thought we could avoid two indirect calls on each
> > ticks and I was also afraid of breaking start/stop original semantics,
> > more especially the role of perf_event_stop/start
> 
> Right, so you lost the fallback to ->enable/->disable, which would break
> hardware PMU implementations that didn't actually implement
> ->start/->stop (pretty much all of them except x86).


Indeed.

