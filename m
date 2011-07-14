Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1GNAzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:55:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60096 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1GNAzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:55:01 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=l8LWmUGdTDcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=EXXXJYmgZYSbIOfU3csA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC 0/4] streamline_config clean-ups
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
In-Reply-To: <1310170759.2780.37.camel@fedora>
References: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
	 <CACqU3MUrCODMx=8Bu+YDxy2BJwjm-77PXFob5OwHn=fr5mTdkg@mail.gmail.com>
	 <1310170759.2780.37.camel@fedora>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 13 Jul 2011 20:54:59 -0400
Message-ID: <1310604899.27864.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-08 at 20:19 -0400, Steven Rostedt wrote:
> On Fri, 2011-07-08 at 17:47 -0400, Arnaud Lacombe wrote:
> > Hi,
> > 
> > On Fri, Jul 1, 2011 at 7:31 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > > Hi,
> > >
> > > The following series attempts to merge some redundants stuff in the kconfig
> > > Makefile, namely how streamline_config learns about its environment, avoids
> > > multi-line shell command in kconfig's Makefile. Seconds commit also removes the
> > > non-portable usage of sed(1) as -i is not POSIX compliant.
> > >
> > > Comments appreciated!
> > >
> > >  - Arnaud
> > >
> > Ping ?

I just tried your patches out. It breaks when we compile for another
directory. I just tried:

$ make LSMOD=/tmp/lsmod O=../machine/build/ localmodconfig

and it it did not work.

-- Steve


