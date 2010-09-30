Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab0I3PFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 11:05:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35726 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab0I3PFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 11:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YU/UEUTuveF8IipTGkFC/gkodA6xyscdTGwc9jbd84t7ZWkG9+1n4FmmpkCd9YVas7
         t4yBy0Wr7AOwVsEhUXl7jjyV67/3AcGFVrL0CuSvtv4/GcKf4kVhzFkhnVxFdyWp4xwq
         Cg82fCPDxW/7UJMpJx+SEBqE3e0t7MmEbmZeU=
Subject: Re: [PATCH 5/5] perf: Declare hw_perf_{dis,en}able() in
 perf_event.h
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1285845732.2144.13.camel@laptop>
References: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
	 <1285583997-1262-6-git-send-email-namhyung@gmail.com>
	 <1285845732.2144.13.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 00:05:37 +0900
Message-ID: <1285859137.1628.4.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-09-30 (목), 13:22 +0200, Peter Zijlstra:
> On Mon, 2010-09-27 at 19:39 +0900, Namhyung Kim wrote:
> > Since they can be defined in arch-specific code declare them in
> > perf_event.h and remove following warnings from sparse:
> > 
> >  kernel/perf_event.c:83:13: warning: symbol 'hw_perf_disable' was not declared. Should it be static?
> >  kernel/perf_event.c:84:13: warning: symbol 'hw_perf_enable' was not declared. Should it be static?
> > 
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> 
> What tree is this against, those function no longer exist!?

That was Linus' tree. Sorry, I didn't check -tip tree.
Please ignore this :-(


-- 
Regards,
Namhyung Kim


