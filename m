Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab2EDNj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:39:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:55565 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab2EDNj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:39:26 -0400
Date: Fri, 4 May 2012 10:39:27 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/3] perf/annotate improvements
Message-ID: <20120504133927.GB10068@infradead.org>
References: <1336062935-19964-1-git-send-email-acme@infradead.org>
 <20120504070048.GA10289@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120504070048.GA10289@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 04, 2012 at 09:00:48AM +0200, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> Hm, this regresses for some symbols, the annotation window only 
> shows this:

I'll check this, and as well provide a "screenshot" feature to write a
__strlen_sse2_pminub.annotation file stripping the spaces all the way to
the scrollbar, to ease posting problems :-)

- Arnaldo
 
> __strlen_sse2_pminub                                                                               
>        │
>        │
> 
> It used to show the full thing:
> 
> __strlen_sse2_pminub                                                                               
>     0.00 :          392a35dbde:   jne    392a35dc30 
> <__strlen_sse2_pminub+0x2a0>                  ▒
>     0.00 :          392a35dbe0:   pcmpeqb 0x40(%rax),%xmm3                                        
> ▒
>     0.00 :          392a35dbe5:   pmovmskb %xmm3,%edx                                             
> ▒
>     0.00 :          392a35dbe9:   sub    %rdi,%rax                                                
> ▒
>     0.00 :          392a35dbec:   bsf    %rdx,%rdx                                                
> ▒
>     0.00 :          392a35dbf0:   add    %rdx,%rax                                                
> ▒
>     0.00 :          392a35dbf3:   add    $0x40,%rax                                               
> ▒
>     0.00 :          392a35dbf7:   retq                                           
> 
> Other symbols are fine.
> 
> 	Ingo
