Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2D1Uio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 16:38:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48115 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753065Ab2D1Uim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 16:38:42 -0400
Message-ID: <1335645521.4191.13.camel@joe2Laptop>
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to
 work with layers
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Date: Sat, 28 Apr 2012 13:38:41 -0700
In-Reply-To: <20120428085223.GB26065@aftab.osrc.amd.com>
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>
	 <1335291342-14922-1-git-send-email-mchehab@redhat.com>
	 <20120427133304.GE9626@aftab.osrc.amd.com>
	 <1335535895.25521.7.camel@joe2Laptop> <4F9AC44A.5000509@redhat.com>
	 <20120428085223.GB26065@aftab.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-28 at 10:52 +0200, Borislav Petkov wrote:
> On Fri, Apr 27, 2012 at 01:07:38PM -0300, Mauro Carvalho Chehab wrote:
> > Yes. This is a common issue at the EDAC core: on several places, it calls the
> > edac debug macros (DEBUGF0...DEBUGF4) passing a __func__ as an argument, while
> > the debug macros already handles that. I suspect that, in the past, the __func__
> > were not at the macros, but some patch added it there, and forgot to fix the
> > occurrences of its call.
> 
> The patch that added it is d357cbb445208 and you reviewed it.
> 
> > This is something that needs to be reviewed at the entire EDAC core (and likely
> > at the drivers).
> 
> Looks like a job for a newbie to get her/his feet wet with kernel work.

Looks to me more like a lazy maintainer/developer who doesn't
want to bother with a few minutes work.


