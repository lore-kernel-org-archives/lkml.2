Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab2JANyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:54:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63816 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2JANyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:54:39 -0400
Subject: Re: [PATCH 11/12] perf tools: Convert to BACKTRACE_SUPPORT
From: Namhyung Kim <namhyung@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Irina Tirdea <irina.tirdea@intel.com>
In-Reply-To: <CANg8OWL1ii9onSA3KDvYQ2Chm5=RcN9AnZebuXe12RSmoR29vw@mail.gmail.com>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
	 <1348824728-14025-12-git-send-email-namhyung@kernel.org>
	 <CANg8OWL1ii9onSA3KDvYQ2Chm5=RcN9AnZebuXe12RSmoR29vw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Oct 2012 22:54:33 +0900
Message-ID: <1349099673.1613.18.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-01 (월), 02:40 +0300, Irina Tirdea:
> > @@ -751,10 +753,8 @@ else
> >  endif
> >
> >  ifdef NO_BACKTRACE

Argh, right.  Thanks for pointing it out.  I double checked other ones
too, and it seems that they don't have the problem.

Arnaldo, what do you want to do with this?

Thanks,
Namhyung


