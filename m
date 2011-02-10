Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab1BJUUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:20:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560Ab1BJUU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:20:28 -0500
Date: Thu, 10 Feb 2011 18:20:23 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Arun Sharma <arun@sharma-home.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: Re: 2.6.37 kernel warning in perf_events code
Message-ID: <20110210202023.GG20676@ghostprotocols.net>
References: <AANLkTi=4_p73eHhQbj5DDDEzTWaLou+u2igiY+yNiPQ9@mail.gmail.com> <20110210190843.GE20676@ghostprotocols.net> <AANLkTi=WRrBnyiDqOeR7PnqVhh8wLFx5W0tgjNaPvkLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=WRrBnyiDqOeR7PnqVhh8wLFx5W0tgjNaPvkLg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 10, 2011 at 12:02:20PM -0800, Arun Sharma escreveu:
> On Thu, Feb 10, 2011 at 11:08 AM, Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
> > Em Wed, Feb 09, 2011 at 06:50:09PM -0800, Arun Sharma escreveu:
> >> [ Not sure if this is known and fixed in newer kernels. My machine
> >> becomes unusable after this warning triggers ]
> >>
> >> perf record -g -p <pid> cs -o csw.data -- sleep 3

Arun, are you shure the above line is right? I guess it should read:

perf record -g -p <pid> -e cs -o csw.data -- sleep 3

To specify the context switches soft event, right?

> > What kernel are you using? Peter, rings any bells?
> 
> Stock 2.6.37.

- Arnaldo
