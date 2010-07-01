Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab0GAT6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:58:04 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:54385 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab0GAT6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:58:00 -0400
Subject: Re: [PATCH 0/2] Yama: add PTRACE exception tracking
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kees Cook <kees.cook@canonical.com>, James Morris <jmorris@namei.org>,
       Christoph Hellwig <hch@infradead.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100701194103.GA26620@hallyn.com>
References: <20100630003844.GE4837@outflux.net>
	 <20100630073158.GA4453@infradead.org>
	 <alpine.LRH.2.00.1007011057520.24202@tundra.namei.org>
	 <20100701044401.GY4837@outflux.net> <20100701132038.GA24394@hallyn.com>
	 <20100701171624.GZ4837@outflux.net>  <20100701194103.GA26620@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Thu, 01 Jul 2010 15:57:55 -0400
Message-ID: <1278014275.15753.207.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 14:41 -0500, Serge E. Hallyn wrote:
> Quoting Kees Cook (kees.cook@canonical.com):
> > > > I still think simple chaining is the way to go.  I want to review the
> > > > earlier discussions first (I think Serge said it was in 2004ish?) before I
> > > > write up anything.  There is, I think, one sticking point, which is
> > > > /proc/self/attr/current, but beyond that, I think some simple
> > > > reorganization of LSM initialization routines and a list that security_*
> > > > walks would be sufficient.
> > > 
> > > In the past, output results for each LSM were simply split by \n or a :
> > > or something, and input was prepended by the LSM name.
> > 
> > This doesn't appear to be true anymore.  Looking at the fs/proc/base.c and
> > security/selinux/hooks.c code, there is no checking for a prepended LSM
> > name.  Maybe that's the first chaining limitation -- you can't chain 2 LSMs
> > that both declare setprocattr hooks.
> 
> No no, Stephen and I were talking about in the stacker patchset, again
> around 2004-2005.  Never went upstream (per 2005 or 2006 ksummit
> agreement).

Patch series was also available from:
http://sourceforge.net/projects/lsm-stacker/files/

Looks like it was last updated in 2006.

-- 
Stephen Smalley
National Security Agency

