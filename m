Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1JQBPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:15:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54678 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab1JQBP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:15:29 -0400
Date: Sun, 16 Oct 2011 23:15:21 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [GIT PULL 0/5] perf/core improvements and fixes
Message-ID: <20111017011521.GD21352@ghostprotocols.net>
References: <1318616873-26739-1-git-send-email-acme@infradead.org>
 <20111015145946.GB9516@elte.hu>
 <4E99BC44.40400@gmail.com>
 <20111015170452.GD29782@elte.hu>
 <4E99C6E6.2040201@gmail.com>
 <20111015190620.GA21352@ghostprotocols.net>
 <4E99DA6C.3030906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E99DA6C.3030906@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Oct 15, 2011 at 01:09:32PM -0600, David Ahern escreveu:
> On 10/15/2011 01:06 PM, Arnaldo Carvalho de Melo wrote:
> >>
> >> It should. The message comes from map__load() when it detects a deleted
> >> mapping such as:
> >>
> >> 7f9e8d5c7000-7f9e8d5c8000 rw-p 0000c000 fd:02 1046947
> >>  /lib64/libpam.so.0.82.2.#prelink#.cM3f72 (deleted)
> >>
> >> I have removed prelink from most of my systems (managed to find one lone
> >> server with the above).
> > 
> > 	Can you send me a patch that clarifies this situation?
> 
> Clarifies in what way? The code checks for "(deleted)" on the dso and
> suggests a restart of the process.

Perhaps telling that prelinking is the reason, so that users that don't
recall updating anything understands the situation.

- Arnaldo
