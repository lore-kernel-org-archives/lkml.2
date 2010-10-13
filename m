Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976Ab0JMEIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 00:08:21 -0400
Received: from tundra.namei.org ([65.99.196.166]:44904 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab0JMEIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 00:08:20 -0400
Date: Wed, 13 Oct 2010 15:07:40 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, paul.moore@hp.com, selinux@tycho.nsa.gov,
        sds@tycho.nsa.gov, jengelh@medozas.de,
        linux-security-module@vger.kernel.org, mr.dash.four@googlemail.com,
        pablo@netfilter.org
Subject: Re: [PATCH 1/5] secmark: do not return early if there was no error
In-Reply-To: <1286927424.2614.15.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1010131507110.3834@tundra.namei.org>
References: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com>  <alpine.LRH.2.00.1010131038160.2949@tundra.namei.org> <1286927424.2614.15.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, Eric Paris wrote:

> On Wed, 2010-10-13 at 10:38 +1100, James Morris wrote:
> > On Tue, 12 Oct 2010, Eric Paris wrote:
> > 
> > > Commit 4a5a5c73 attempted to pass decent error messages back to userspace for
> > > netfilter errors.  In xt_SECMARK.c however the patch screwed up and returned
> > > on 0 (aka no error) early and didn't finish setting up secmark.  This results
> > > in a kernel BUG if you use SECMARK.
> > > 
> > 
> > Does this need to go into current Linus?
> 
> It's been broken since v2.6.35-rc1 so it's not exactly new, but yes,
> it's broken and will bug like this in current Linus.

Acked-by: James Morris <jmorris@namei.org>

(Guessing this should go in via the networking tree).


-- 
James Morris
<jmorris@namei.org>
