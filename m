Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab2HISWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:22:49 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39529 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab2HISWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:22:48 -0400
Date: Thu, 9 Aug 2012 19:27:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/3] perf tools: Initial bash completion support
Message-ID: <20120809192706.625671f0@pyramind.ukuu.org.uk>
In-Reply-To: <20120809171419.GC4084@infradead.org>
References: <1344522713-27951-1-git-send-email-fweisbec@gmail.com>
	<1344522713-27951-2-git-send-email-fweisbec@gmail.com>
	<20120809163515.GA4084@infradead.org>
	<5023E7F3.8090701@gmail.com>
	<20120809171419.GC4084@infradead.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 3rd patch should fix this.
> 
> Huh? The problem is not /etc/bash_completion.d/ not existing, it exists,
> its just that I'm not using sudo nor installing as root, this new bash
> completion file is the only one that is being installed on the root
> filesystem, all others are in ~acme/

And even with permissions it might not have the right security labels on
a well secured box.

It's a neat little script (or once its been properly security audited
will be) but IMHO it belongs in the distro bash script packages.

Alan
