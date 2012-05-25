Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2EYOkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:40:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51998 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab2EYOki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:40:38 -0400
Date: Fri, 25 May 2012 11:40:34 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] perf tools: fix thread_map__new_by_pid_str() memory
 leak in error path
Message-ID: <20120525144034.GF2336@infradead.org>
References: <1337952109-31995-1-git-send-email-fbuihuu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337952109-31995-1-git-send-email-fbuihuu@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 25, 2012 at 03:21:49PM +0200, Franck Bui-Huu escreveu:
> namelist array (including its content) was not freed if we fail
> to realloc a new 'threads' structure.
> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>

Thanks, applied.
