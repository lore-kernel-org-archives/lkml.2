Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1BITuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:50:51 -0500
Received: from brother.balabit.com ([195.70.62.219]:56218 "EHLO
	lists.balabit.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1BITuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:50:50 -0500
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
From: Gergely Nagy <algernon@balabit.hu>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110204171502.GA24226@mail.hallyn.com>
References: <1296733177.14846.26.camel@moria>
	 <20110203153252.GA24153@mail.hallyn.com>
	 <20110204160513.GB17396@mail.hallyn.com> <1296837186.24742.15.camel@moria>
	 <20110204171502.GA24226@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Organization: BalaBit
Date: Wed, 09 Feb 2011 20:50:47 +0100
Message-ID: <1297281047.13055.25.camel@luthien.mhp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 17:15 +0000, Serge E. Hallyn wrote:
[...snip...] 
> > > James, do you mind taking this patch?
> > 
> > Would it be possible to change the commit message to say that 1 would be
> > the default? Just to avoid future confusion... (having it at 0 default
> > later would just postpone the userspace breakage)
> > 
> 
> Good point, attached.
[...snip...]

Just a friendly reminder that - as far as I see - neither this, nor
anything similar, did not make it into Linus' tree yet.

I'd love if it would, would hate to tell users to avoid 2.6.38 due to it
being broken.

-- 
|8]



