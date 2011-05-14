Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1ENKSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:18:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51011 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab1ENKSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:18:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Bk8IcvMRnolNT+cRbs93Q2QMuQCJ1L/jEOeDI+EYs1mAEcgn0V8GqXYZpV97oh/v8r
         jRZVK8ZTrR1WVcZiT3CR5HBgCiZT60XoThOT6qQMOjeqinDNb1t+ibgGexuyCLeSZg+N
         faOsl+emuEWIjLhZGPK8w2xoqwBODYTkyTwVE=
Date: Sat, 14 May 2011 12:18:07 +0200
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>,
        Jian Peng <jipeng2005@gmail.com>
Cc: Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: AHCI driver problem on ICH (Re: AHCI driver problem on
 SB700/SB800 w/ Acer Ferrari One)
Message-ID: <20110514101807.GA23665@htj.dyndns.org>
References: <201105120025.34531.rjw@sisk.pl>
 <BANLkTimqxmbpP1-+HxhPQS-YoLTh=bHd1Q@mail.gmail.com>
 <201105132222.11582.rjw@sisk.pl>
 <201105132244.29605.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105132244.29605.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 13, 2011 at 10:44:29PM +0200, Rafael J. Wysocki wrote:
> On Friday, May 13, 2011, Rafael J. Wysocki wrote:
> > On Friday, May 13, 2011, Tejun Heo wrote:
> > > Hello,
> > > 
> > > Can you guys please take a look at bug#34692?  It seems to be the same problem.
> > > 
> > >   https://bugzilla.kernel.org/show_bug.cgi?id=34692
> > 
> > Yes, same issue.
> > 
> > > The offending commit seems to be 270dac35c2.  Does reverting it
> > > resolves the problem for you guys too?
> > 
> > Yes, it does.
> 
> Would you object if I asked Linus to revert that commit?

Not at all.  I think that's the best option at this point.  I'll send
revert patch right now.

Thanks.

-- 
tejun
