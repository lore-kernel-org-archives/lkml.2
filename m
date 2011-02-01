Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1BASYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:24:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54372 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1BASYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:24:13 -0500
Date: Tue, 1 Feb 2011 16:24:01 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 1/2] perf tools: Remove verbose build messages for the
 python binding
Message-ID: <20110201182401.GB20938@ghostprotocols.net>
References: <1296581395-30663-1-git-send-email-acme@infradead.org>
 <1296581395-30663-2-git-send-email-acme@infradead.org>
 <1296581819.26581.247.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296581819.26581.247.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 01, 2011 at 06:36:59PM +0100, Peter Zijlstra escreveu:
> This won't fix this, right?
> 
> running build_ext
> error: invalid Python installation: unable to open /usr/lib64/python2.6/config/Makefile (No such file or directory)
> make: *** [pyrf] Error 1

Right, I'll leverage the python script test for python-dev being present
in the system.

- Arnaldo
