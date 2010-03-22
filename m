Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab0CVVMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:12:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab0CVVMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:12:05 -0400
Date: Mon, 22 Mar 2010 18:11:47 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] perf report: newt callgraphs
Message-ID: <20100322211147.GQ2873@ghostprotocols.net>
References: <1269291169-29820-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1269291169-29820-1-git-send-email-acme@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 22, 2010 at 05:52:49PM -0300, Arnaldo Carvalho de Melo escreveu:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Starts collapsed, allows annotating by pressing 'A' or 'a' on the symbol, be it
> the top level one or any of the symbols in the chains.
> 
> It (ab)uses the only tree widget in newt, that is actually a checkbox tree that
> we use with just one option ('.'), end result is usable but we really need to
> create a custom widget tree so that we can use the data structures we have
> (hist_entry rb_tree + callchain rb_tree + lists), so that we reduce the memory
> footprint by not creating a mirror set of data structures in the
> newtCheckboxTree widget.
> 
> Thanks to Frédéric Weisbacker for fixing the orphanage problem in
> 301fde2, without that we were tripping a newt bug (fix already sent to
> newt's maintainer).

For the curious, here is a screenshot:

http://tglx.de/~acme/perf-newt-callgraph.png

- Arnaldo
