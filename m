Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab2IMOmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:42:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab2IMOmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:42:07 -0400
Date: Thu, 13 Sep 2012 00:51:15 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Robert Richter <robert.richter@amd.com>, mingo@kernel.org, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf hists: Introduce perf_hpp for hist period
 printing
Message-ID: <20120913035115.GD557@infradead.org>
References: <1346640790-17197-2-git-send-email-namhyung@kernel.org>
 <tip-ea251d51d2c7d7233790123227f787c477f567f5@git.kernel.org>
 <20120912172641.GB29278@erda.amd.com>
 <20120912184815.GC557@infradead.org>
 <87y5ke8wxv.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5ke8wxv.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 13, 2012 at 11:43:08AM +0900, Namhyung Kim escreveu:
> On Wed, 12 Sep 2012 15:48:15 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Sep 12, 2012 at 07:26:41PM +0200, Robert Richter escreveu:
> >> Moving and changing the code at the same time make the patch
> >> unreviewable. So no clue that's the problem here.

> > Yeah, that was unfortunate (movind and changing), we need to try hard
> > not to do that...

> Okay, will be careful next time.

Its a neverending discipline to follow :-\ But it can be fun, keep it
up!

> > Anyway, Namhyung, can you take a look at this?
 
> Sure, I'll take a look.

Thanks!

- Arnaldo
