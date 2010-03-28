Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0C1FEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 01:04:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33870 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0C1FEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 01:04:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RQ9wiguZ83gi0KluDN/iPMzRboAPACLXBu4q2/oZBqLDS76mGQscSeXyCUds+KrFwx
         e3fk7D0s3vGCms9bW0Km6wjjPO/fOr2BLNUjiv47HYsMAhhvhU9cZabznCIEheP1Sjqf
         nU6Gzz1kRpkzv3MZCVIqW2SMwYumUvAv1LrAE=
Subject: Re: [RFC PATCH 0/7] perf: 'live mode'
From: Tom Zanussi <tzanussi@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, k-keiichi@bx.jp.nec.com
In-Reply-To: <20100327230055.GJ23594@ghostprotocols.net>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
	 <20100304111856.GE21977@elte.hu>
	 <20100327230055.GJ23594@ghostprotocols.net>
Content-Type: text/plain
Date: Sun, 28 Mar 2010 00:04:44 -0500
Message-Id: <1269752684.7377.5.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-27 at 20:00 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Mar 04, 2010 at 12:18:56PM +0100, Ingo Molnar escreveu:
> > * Tom Zanussi <tzanussi@gmail.com> wrote:
> > 
> > > Currently, a perf session entails two steps: first 'perf record' or 'perf 
> > > trace record' records the perf data to disk, then 'perf report' or 'perf 
> > > trace report' reads the saved data from disk and reports the results.
> > > 
> > > This experimental patchset makes some changes to perf that instead allow the 
> > > perf data to be piped directly from the record step to the report step, 
> > > without ever touching the disk.
> > 
> > Very nice!
> > 
> > > Obviously, it would be better to have a real top-like display for these 
> > > rather than a continuously scrolling mode like this, and of course it will 
> > > be much more useful once we get the syscall name injection events going (the 
> > > column on the left shows syscall numbers only).
> > 
> > It's still useful for ad-hoc tracing!
> > 
> > Side-note, it might make sense to expose the 'clear' escape sequence somehow 
> > in an easy fashion:
> > 
> > [H[2J
> > 
> > to make it non-scrolling ;-) via a pre-provided method.
> > 
> > > There are some rough edges and inefficiencies, and I guess 'event injection' 
> > > may be a better way to do this in the end, but it seems to work pretty well 
> > > already, and I think it shows how useful such a capability can be.
> > 
> > I'm all for it. Frederic, Steve, what do you think?
> 
> ITs really nice indeed, I'm reviewing the patches and will test them
> after weekend, it fits nicely with the idea of unifying top and report,
> i.e. the refresh thing he mentions could do the decay as well if a
> parameter is set.
> 
> Thnaks Frederic for pointing this patchset to me.
> 
> Great work!

Thanks!  Just FYI, I have a new version of this patchset that I'm hoping
to post in the next couple of days.  It adds the refresh sequence and a
specifiable delay, among other things (like bugfixes)...

Tom

> 
> - Arnaldo

