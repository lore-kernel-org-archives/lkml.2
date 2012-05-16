Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab2EPPuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:50:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36682 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2EPPuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:50:06 -0400
Date: Wed, 16 May 2012 12:50:01 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf target: Add need_mmap field
Message-ID: <20120516155000.GF7864@infradead.org>
References: <1337161549-9870-1-git-send-email-namhyung.kim@lge.com>
 <1337161549-9870-3-git-send-email-namhyung.kim@lge.com>
 <20120516152831.GE7864@infradead.org>
 <4FB3C895.1050508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB3C895.1050508@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 16, 2012 at 09:32:37AM -0600, David Ahern escreveu:
> On 5/16/12 9:28 AM, Arnaldo Carvalho de Melo wrote:
> >Em Wed, May 16, 2012 at 06:45:49PM +0900, Namhyung Kim escreveu:
> >>If perf doesn't mmap on event (like perf stat), it
> >>should not create per-task-per-cpu events. So just
> >>use a dummy cpu map to create a per-task event for
> >>this case.
> >
> >Humm, perhaps target.no_mmap is better? I.e. just perf-stat would set
> >it.
> >
> 
> That gets back to the potential double negation Ingo frowns upon (!no_mmap).

Ok, but this really doesn't feel like a good name :-\ Short of ideas
now tho.

- Arnaldo
