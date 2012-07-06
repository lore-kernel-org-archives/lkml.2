Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab2GFMm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:42:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28541 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2GFMm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:42:57 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TktROVI7lUoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=D19gQVrFAAAA:8 a=POFbXC6fAAAA:20 a=6UbPHLlvKfP0LD6110wA:9 a=PUjeQqilurYA:10 a=ARQLUNvo-bYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1341578575.14828.6.camel@gandalf.stny.rr.com>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
From: Steven Rostedt <rostedt@goodmis.org>
To: Glauber Costa <glommer@parallels.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ksummit-2012-discuss@lists.linux-foundation.org
Date: Fri, 06 Jul 2012 08:42:55 -0400
In-Reply-To: <4FF6C148.7030402@parallels.com>
References: <alpine.LFD.2.02.1206152313310.3086@ionos>
	 <20120615233413.GB8894@kroah.com>
	 <alpine.LFD.2.02.1206161103320.3086@ionos>
	 <20120616072906.7469ec24@tpl.lwn.net> <20120620195121.GA1719@fieldses.org>
	 <4FF6B32A.7070006@parallels.com>
	 <20120706095450.GB7728@somewhere.redhat.com>
	 <20120706101149.GA26028@localhost.localdomain>
	 <4FF6BFC7.9060405@linux.vnet.ibm.com> <4FF6C148.7030402@parallels.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 14:43 +0400, Glauber Costa wrote:

> > Please no!
> > I don't see why we should clutter the changelog with tags for reasons as
> > unimportant as measuring some patch's value!
> > 
> Stronger: Having the maintainer to do more work is hardly a way to decrease
> the amount of work he does. (Well, it could be in some cases, but not in
> this)

Strongest: We actually implemented this. It was called 'Impact' tags
(search the git logs). Linus *hated* them. He got really upset and
flamed us for doing it.

  https://lkml.org/lkml/2009/4/15/296

Basically it's duplicating the subject line. The subject line should
have the impact (worth) of the patch. Heck, we should just add
'/trivial' to the subject. Like "x86/trivial: clean white space in x.c".

Or /doc or /comment or whatever. That should not be a problem, searches
are nicer on git log --pretty=oneline, and we should push to have all
non functional changes have such a tag in the subject. Then we can split
these changes out from functional changes.

There, solved ;)

-- Steve


