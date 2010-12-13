Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab0LMOgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:36:37 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60073 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0LMOgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:36:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=KblIK3h47LAV9kRKC4hO0/4SRPylV346BuqUa/7guFlqtDPlepoCUh49uwkVm60h0r
         tR0vyh3OvaaJnBg8gsn6RccinLJEUkrMs5MvWtupIlCJsuQseQZE7cDz0+nNcWJzfVW2
         NUwfPjTMlnzaBlSoGUjnwkRfdLrGChQeXJQHA=
Date: Mon, 13 Dec 2010 12:36:30 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andres Freund <andres@anarazel.de>
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Costly Context Switches
Message-ID: <20101213143630.GI5407@ghostprotocols.net>
References: <20101212151112.GE26583@charite.de>
 <201012131525.54577.andres@anarazel.de>
 <20101213142911.GH5407@ghostprotocols.net>
 <201012131530.46633.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012131530.46633.andres@anarazel.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 13, 2010 at 03:30:46PM +0100, Andres Freund escreveu:
> On Monday 13 December 2010 15:29:11 Arnaldo Carvalho de Melo wrote:
> > Em Mon, Dec 13, 2010 at 03:25:54PM +0100, Andres Freund escreveu:
> > > Hm. Its also a good starting point but it may be harder to see the
> > > differences between dovecot-2.0 and dovecot-1.2 that way because its
> > > harder to see if its

> > Well, for that he can try 'perf diff', i.e.:

> > 1. run perf record on dovecot-1.2
> > 2. run perf record on dovecot-2.0
> > 3. perf diff
> Wow. That one I didnt know about yet.
> 
> Too bad that perf docs/examples are so spread out...

There is a bit of info on these places:

http://vger.kernel.org/~acme/perf/lk2010-perf-paper.pdf
http://vger.kernel.org/~acme/perf/perf-plumbers2010.pdf

Also please consider helping organizing the existing documentation in a
way that gets them more easily accessible :-)

- Arnaldo
