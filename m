Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0CYOqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:46:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53720 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab0CYOqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:46:43 -0400
X-Authority-Analysis: v=1.0 c=1 a=InLQgaHwsNUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=GTLNVe6K6qRPn76mrksA:9 a=1NV20r9Zx6jxV8kI00kA:7 a=UuSO39vrwlgctA6QJUuPOhk8oOwA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] trace-cmd: Add BUILDING and INSTALL instructions to
 README
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Clark Williams <williams@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <1709186929.883731269527013185.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <1709186929.883731269527013185.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Mar 2010 10:46:40 -0400
Message-ID: <1269528400.2957.4143.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 10:23 -0400, John Kacur wrote:
> ----- "Steven Rostedt" <rostedt@goodmis.org> wrote:
> 
> > On Thu, 2010-03-25 at 10:24 +0100, John Kacur wrote:
> > > - Add BUILDING and INSTALL instructions to the README
> > > - Change Makefile so that messages don't appear like errors.
> > 
> > Thanks,
> > 
> > Did you rebase your repo or do I need to pull in the other patches
> > from
> > the mbox?
> 
> I rebased the repo and did a push -f
> 

Thanks I'll pull it.


> > > +
> > > +Note: The default install is relative to /usr/local
> > > +    The default install directory is /usr/local/bin
> > > +    The default plugin directory is
> > /usr/local/share/trace-cmd/plugins
> > > +
> > > +To change the default, you can set 'prefix', eg
> > > +mkdir $HOME/test-trace
> > > +make prefix=$HOME/test-trace
> > > +make prefix=$HOME/test-trace install
> > 
> > Looks good, but I would use the example of this:
> > 
> > make prefix=~
> > make prefix=~ install
> > 
> > The above would install the executables into your home directory
> > ~/bin
> > and the plugins into ~/.trace-cmd/plugins
> > 
> 
> 
> That is an oddity, I tried to show a general case.
> We could append more info about that special case if you wish.

Yeah, it was the default case ;-)

The general case would probably be better to:

make prefix=/usr

-- Steve


