Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422Ab1JGAZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 20:25:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab1JGAZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 20:25:34 -0400
Subject: Re: Including C6X in linux-next
From: Mark Salter <msalter@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>, linux-next@vger.kernel.org
Date: Thu, 06 Oct 2011 20:25:30 -0400
In-Reply-To: <20111007102953.7b533ec58dd613b9fd78a198@canb.auug.org.au>
References: <1317917085.2703.16.camel@deneb.redhat.com>
	 <20111007102953.7b533ec58dd613b9fd78a198@canb.auug.org.au>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1317947131.2300.6.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 10:29 +1100, Stephen Rothwell wrote:
> Hi Mark,
> 
> On Thu, 06 Oct 2011 12:04:44 -0400 Mark Salter <msalter@redhat.com> wrote:
> >
> > All of the patches in the latest C6X patch set have gotten Acked-bys, so
> > I guess its time to include it in the linux-next tree. The patches are
> > available on the "for-linux-next" branch at:
> > 
> >    http://linux-c6x.org/git/projects/linux-c6x-upstreaming.git
> 
> I had a look at this and unfortunately you have based it on linux-next.
> I cannot use it like that.  You need to rebase this onto Linus' tree,
> sorry.  (Also, I used the git://... version of the URL as that is more
> efficient than http://.. for updting git trees).
> 

Okay, it is now rebased on Linus' tree.


