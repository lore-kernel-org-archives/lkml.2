Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab2DYKVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:21:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757695Ab2DYKVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:21:30 -0400
Date: Wed, 25 Apr 2012 07:21:24 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] perf tools: Fix include header files in
 util/parse-events.h
Message-ID: <20120425102124.GE28056@infradead.org>
References: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
 <1333643188-26895-2-git-send-email-robert.richter@amd.com>
 <20120424165344.GH9747@erda.amd.com>
 <20120424173555.GD28056@infradead.org>
 <20120424175804.GJ9747@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120424175804.GJ9747@erda.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Apr 24, 2012 at 07:58:04PM +0200, Robert Richter escreveu:
> On 24.04.12 14:35:55, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Apr 24, 2012 at 06:53:44PM +0200, Robert Richter escreveu:
> > > On 05.04.12 18:26:25, Robert Richter wrote:
> > > > Include header fixes for
> > > > 
> > > > ... bool:
> > > > 
> > > >  util/parse-events.h:31: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘have_tracepoints’
> > > > 
> > > > ... and types.h:
> > > > 
> > > >  util/parse-events.h:28: error: expected ‘)’ before ‘config’
> > > >  util/parse-events.h:34: error: expected declaration specifiers or ‘...’ before ‘u64’
> > > >  util/parse-events.h:45: error: expected ‘)’ before ‘type’
> > > > 
> > > > This happens if now other include files are included before
> > > > util/parse-events.h.
> > > > 
> > > > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > > 
> > > Arnaldo,
> > > 
> > > is it your intention that you didn't apply this patch?
> > 
> > Is this on perf/urgent or perf/core? In what system does this happen?
> 
> Neither, I stumbled over this while working on a modified version of
> perf tools. The interface definition of util/parse-events.h contains
> type bool and u64, but both are not defined. Thus, including
> parse-events.h independently of other header files will raise this
> compile errors. It took me some time to figure out what happened so I
> think it is worth fixing it.

Cool, that explains why I have not stumbled on it, thanks for
explaining, will apply.

- Arnaldo
