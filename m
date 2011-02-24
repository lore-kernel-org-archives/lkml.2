Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1BXReb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:34:31 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41206 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029Ab1BXRea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:34:30 -0500
X-Sasl-enc: kLlQi8VqEatNz7cE5NQ2LlbdgwuuH5RugZC3IHKqgfpE 1298568869
Date: Thu, 24 Feb 2011 14:34:17 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dan Carpenter <error27@gmail.com>, Greg KH <gregkh@suse.de>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        Eugene Teo <eugeneteo@kernel.sg>,
        Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] debugfs: only allow root access to debugging
 interfaces
Message-ID: <20110224173417.GE19481@khazad-dum.debian.net>
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com>
 <1298398198-18482-2-git-send-email-kees.cook@canonical.com>
 <20110222181613.GU4000@outflux.net>
 <20110222191333.GA9991@suse.de>
 <20110222192248.GX4000@outflux.net>
 <20110222193314.GA11033@suse.de>
 <20110222202915.GC1966@bicker>
 <20110222205847.GA1867@khazad-dum.debian.net>
 <20110224163844.GC888@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224163844.GC888@home.goodmis.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Steven Rostedt wrote:
> On Tue, Feb 22, 2011 at 05:58:47PM -0300, Henrique de Moraes Holschuh wrote:
> > I do wish this went in.  debugfs is a hazard, both security-wise and
> > kernel-quality wise.  Anything that has to end up enabled in a distro
> > kernel really does not belong in debugfs.  In fact, if you would object
> > to a kernel taint if a feature is used, IMO it certainly don't belong on
> > debugfs.
> 
> It was also because we had no idea how ftrace was going to be used and
> what the final ABI was going to be. I was hoping that we can experiment
> with the interface and after some time we could move it out of debugfs
> with a stable ABI. But this, for various reasons, never materialized.
> 
> Currently things are still in a large flux, and I do not know how this
> will play out. Although the changes in /debugfs/tracing has toned down a
> lot, there's also the work going in on how to merge perf and ftrace.
> This may start changes as well, and perhaps deprecate interfaces. I
> don't know.

How will that play with Linus' ruling that "you shipped it, someone used it,
it becomes an stable ABI" ?

Some middle ground is clearly needed, here.  

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
