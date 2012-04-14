Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2DNQ0w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:26:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab2DNQ0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:26:50 -0400
Date: Sat, 14 Apr 2012 13:26:31 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf ui annotate browser: Allow toggling addr
 offset view
Message-ID: <20120414162631.GC22114@infradead.org>
References: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org>
 <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>
 <20120414005921.GA22114@infradead.org>
 <20120414084616.GA28505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120414084616.GA28505@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Apr 14, 2012 at 10:46:16AM +0200, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > > Sure, leave some magic keycombination to get the "full 
> > > information", but ..
> > 
> > Yeah, we have o to toggle offset view + s to toggle source 
> > code view, etc.
> 
> I suspect the default view should be the 'most intelligent' mode 
> of assembly output we can offer - with easy toggles for the rare 
> cases where someone would like to do something special, plus 
> .perfconfig overrides for those with weird workflows and those 
> with a taste different from ours.

Agreed, that is the plan.
 
- Arnaldo
