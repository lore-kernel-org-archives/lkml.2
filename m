Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab0JCKMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 06:12:14 -0400
Received: from ist.d-labs.de ([213.239.218.44]:41512 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab0JCKMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 06:12:13 -0400
Date: Sun, 3 Oct 2010 12:12:09 +0200
From: Florian Mickler <florian@mickler.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tmhikaru@gmail.com, linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: PROBLEM: Unusually high load average when idle in 2.6.35,
 2.6.35.1 and later
Message-ID: <20101003121209.586f7b6b@schatten.dmk.lab>
In-Reply-To: <1286095268.2144.119.camel@laptop>
References: <20101001035321.GA2360@roll>
	<20101001094814.GA5029@roll>
	<20101003030254.GA4901@roll>
	<1286095268.2144.119.camel@laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Oct 2010 10:41:08 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2010-10-02 at 23:02 -0400, tmhikaru@gmail.com wrote:
> >  The load average statistic is indeed broken somehow, and I
> > did bisect it down to where the problem began, however there seems to be no
> > performance problem related to it I can find. 
> 
> Chase, anything you can see broken with this stuff?

Peter, do you think it would be worthwile to test a kernel with the
low load-averages in NOHZ=disable mode? The bisected commit claims to
fix a NOHZ issue with the load average. So if the new figures are the
correct ones, they should be somehow similar to the figures before
with NOHZ? Or am I on the wrong track here?

Regards,
Flo
