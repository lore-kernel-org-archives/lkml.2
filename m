Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1BWHfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 02:35:23 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:38895 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753175Ab1BWHfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 02:35:22 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+56KYn9+G5iHUlolwnydxkl8AkxmwaWSu2Usbvdi
	Yt+jOKwPsYj5gt
Subject: Re: [GIT PULL 0/2] perf/core TUI live annotate and a cleanup
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <20110223072842.GC15175@elte.hu>
References: <1298400790-29453-1-git-send-email-acme@infradead.org>
	 <20110223072842.GC15175@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 08:35:17 +0100
Message-ID: <1298446517.7856.143.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 08:28 +0100, Ingo Molnar wrote:
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > Hi Ingo,
> > 
> >         Please consider pulling from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> > 
> > 	Mike, if you can give it some stress, I'd appreciate.
> > 
> > Regards,
> > 
> > - Arnaldo
> > 
> > Arnaldo Carvalho de Melo (2):
> >   perf probe: Remove redundant checks
> >   perf top: Live TUI Annotation
> 
> Yummie! :-)

(indeed, I will take it out for a spin)

