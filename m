Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1GIATk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 20:19:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1GIATg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 20:19:36 -0400
Subject: Re: [RFC 0/4] streamline_config clean-ups
From: Steven Rostedt <srostedt@redhat.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <CACqU3MUrCODMx=8Bu+YDxy2BJwjm-77PXFob5OwHn=fr5mTdkg@mail.gmail.com>
References: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
	 <CACqU3MUrCODMx=8Bu+YDxy2BJwjm-77PXFob5OwHn=fr5mTdkg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 08 Jul 2011 20:19:19 -0400
Message-ID: <1310170759.2780.37.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-08 at 17:47 -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Fri, Jul 1, 2011 at 7:31 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > Hi,
> >
> > The following series attempts to merge some redundants stuff in the kconfig
> > Makefile, namely how streamline_config learns about its environment, avoids
> > multi-line shell command in kconfig's Makefile. Seconds commit also removes the
> > non-portable usage of sed(1) as -i is not POSIX compliant.
> >
> > Comments appreciated!
> >
> >  - Arnaud
> >
> Ping ?

Ah sorry, I do plan on looking at this but have been busy doing other
things. Note, if you want a quicker response, mail me at
rostedt@goodmis.org. I mostly just get spam in my redhat.com account,
and do not have the patch filters I do with my goodmis.org account.
Speaking of which, you still want [PATCH] in your subject. ie.
[RFC][PATCH 0/4] ....

My procmail moves emails to me with [.*PATCH.*] into a separate folder
that I look at to put into my todo list.

Thanks,

-- Steve

> 
> Thanks,
>  - Arnaud
> 
> > ps: I'm not really a huge fan of the direct export of MAKECMDGOALS, maybe should
> > it be KBUILD_MAKECMDGOALS.
> >
> > Arnaud Lacombe (4):
> >  kbuild: export MAKECMDGOALS
> >  kconfig/streamline_config.pl: directly access LSMOD
> >  kconfig/streamline_config.pl: merge local{mod,yes}config
> >  kconfig/streamline_config.pl: move config generation to script
> >
> >  Makefile                             |    3 ++
> >  scripts/kconfig/Makefile             |   40 +--------------------------------
> >  scripts/kconfig/localconfig.sh       |   20 +++++++++++++++++
> >  scripts/kconfig/streamline_config.pl |   19 +++++++++++++--
> >  4 files changed, 41 insertions(+), 41 deletions(-)
> >  create mode 100755 scripts/kconfig/localconfig.sh
> >
> > --
> > 1.7.3.4.574.g608b.dirty
> >
> >


