Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423Ab0HFOj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:39:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:54277 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab0HFOj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:39:26 -0400
Date: Fri, 6 Aug 2010 11:39:12 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: fweisbec@gmail.com, mingo@elte.hu, peterz@infradead.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC PATCH 7/9] perf: Export cpumap
Message-ID: <20100806143912.GB13780@ghostprotocols.net>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
 <1281104713-23141-8-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281104713-23141-8-git-send-email-bp@amd64.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 06, 2010 at 04:25:11PM +0200, Borislav Petkov escreveu:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Export cpu counting and cpumap manipulating utils for general use. This
> pulls ctype.c along.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Is this independent of previous patches? I.e. to be applied to current
perf/core?

- Arnaldo
