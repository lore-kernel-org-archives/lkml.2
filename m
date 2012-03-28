Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab2C1OeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:34:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:40646 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216Ab2C1OeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:34:09 -0400
Date: Wed, 28 Mar 2012 11:33:35 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, ananth@in.ibm.com,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, rostedt@goodmis.org
Subject: Re: [RESEND]Re: [PATCH] perf - probe finder fails to resolve
 function name to address
Message-ID: <20120328143335.GC8482@infradead.org>
References: <4F6AF410.1010400@linux.vnet.ibm.com>
 <4F6AFD92.4030603@linux.vnet.ibm.com>
 <4F6C721B.9060807@hitachi.com>
 <4F703FB9.9020407@linux.vnet.ibm.com>
 <4F704A1E.2040401@hitachi.com>
 <20120328114745.GA17936@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328114745.GA17936@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 28, 2012 at 01:47:45PM +0200, Ingo Molnar escreveu:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> > > Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
> > 
> > Well, OK. This looks good for me too :)
> > 
> > Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Ok, someone mind sending me the final, agreed upon version, with 
> full explanation and Acked-by's included?

I'll do it.

Waiting a bit before that for the bison/flex resolution.

- Arnaldo
