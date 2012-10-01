Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab2JAOYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:24:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51999 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2JAOYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:24:49 -0400
Date: Mon, 1 Oct 2012 07:24:43 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH 11/12] perf tools: Convert to BACKTRACE_SUPPORT
Message-ID: <20121001142443.GA9829@ghostprotocols.net>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
 <1348824728-14025-12-git-send-email-namhyung@kernel.org>
 <CANg8OWL1ii9onSA3KDvYQ2Chm5=RcN9AnZebuXe12RSmoR29vw@mail.gmail.com>
 <1349099673.1613.18.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349099673.1613.18.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 01, 2012 at 10:54:33PM +0900, Namhyung Kim escreveu:
> 2012-10-01 (월), 02:40 +0300, Irina Tirdea:
> > > @@ -751,10 +753,8 @@ else
> > >  endif
> > >
> > >  ifdef NO_BACKTRACE
> 
> Argh, right.  Thanks for pointing it out.  I double checked other ones
> too, and it seems that they don't have the problem.
> 
> Arnaldo, what do you want to do with this?

Just resubmit this one, I removed it from my local tree, where I have
the others applied.
 
> Thanks,
> Namhyung
> 
