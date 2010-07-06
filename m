Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab0GFNoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 09:44:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:50597 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0GFNoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 09:44:01 -0400
Date: Tue, 6 Jul 2010 10:43:48 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Conny Seidel <conny.seidel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 1/5] perf tools: Fix fallback to cplus_demangle() when
	bfd_demangle() is not available
Message-ID: <20100706134348.GC26192@ghostprotocols.net>
References: <1278378276-25872-1-git-send-email-acme@infradead.org> <1278378276-25872-2-git-send-email-acme@infradead.org> <20100706065904.GC16224@elte.hu> <20100706103103.3b22f53a@marah.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100706103103.3b22f53a@marah.osrc.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 06, 2010 at 10:31:03AM +0200, Conny Seidel escreveu:
> On Tue, 6 Jul 2010 02:59:04 -0400 Ingo Molnar <mingo@elte.hu> wrote:
> >Since 3.81 is the latest Make version and 3.80 is just one step before
> >that, shouldnt we cherry-pick this into perf/urgent? (or is current
> >upstream unaffected?)
> 
> Current upstream is also affected. So it makes sense to put it in
> perf/urgent.

Can you please check if that patch applies to perf/urgent?
 
- Arnaldo
