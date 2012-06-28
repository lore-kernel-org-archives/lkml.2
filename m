Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab2F1Kce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:32:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228Ab2F1Kcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:32:33 -0400
Date: Thu, 28 Jun 2012 12:32:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jovi Zhang <bookjovi@gmail.com>, mingo@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: fix wrong hw_breakpoint documentation
Message-ID: <20120628103223.GA1055@krava.redhat.com>
References: <CACV3sbKFcHgai6AzKGrf=LEb67VjZXjMUqMQuXAOUmby7CeiJg@mail.gmail.com>
 <87fw9hyvt5.fsf@sejong.aot.lge.com>
 <20120627161557.GA3878@infradead.org>
 <20120627190725.GA1380@krava.redhat.com>
 <1340827102.10063.72.camel@twins>
 <20120627201928.GA1008@krava>
 <877gusz0hg.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gusz0hg.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 10:30:51AM +0900, Namhyung Kim wrote:
> On Wed, 27 Jun 2012 22:19:28 +0200, Jiri Olsa wrote:
> > On Wed, Jun 27, 2012 at 09:58:22PM +0200, Peter Zijlstra wrote:
> >> On Wed, 2012-06-27 at 21:07 +0200, Jiri Olsa wrote:
> >> > -modifier_bp    [rwx]
> >> > +modifier_bp    [rwx]{1,3}
> >> > 
> >> > and fail parse_breakpoint_type function for nonsense types
> >> 
> >> If you're going to modify parse_breakpoint_type() to fail on nonsense
> >> types, you might as well do the + thing, right?
> >> 
> >> Doesn't really matter that much though ;-)
> >
> > yo ;-)
> 
> So, are you ok to resend the original patch with your ack? Or will you
> send the above soon?

I can send the change by the end of the week

jirka
