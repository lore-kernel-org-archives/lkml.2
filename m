Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab2FQBNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 21:13:19 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57472 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2FQBNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 21:13:18 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 16 Jun 2012 18:13:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "ksummit-2012-discuss@lists.linux-foundation.org" 
	<ksummit-2012-discuss@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND] Discussion: role of the
 maintainer?
Message-ID: <20120617011321.GA29437@roeck-us.net>
References: <1339875074.8267.87.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339875074.8267.87.camel@lade.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 07:31:19PM +0000, Myklebust, Trond wrote:
> Hi,
> 
> This is a spin off from the discussion topic that was started by Thomas
> Gleixner. I'd like to turn this into a full discussion on the role of
> the Linux Maintainer.
> 
> Currently, the Linux maintainer appears to be responsible for filling
> all of the traditional roles of software architect, software developer,
> patch reviewer, patch committer, and software maintainer.
> 
> My question is whether or not there might be some value in splitting out
> some of these roles, so that we can assign them to different people, and
> thus help to address the scalability issues that Thomas raised? For
> instance, would it be useful to have a separate 'software maintainer'
> role for dealing with post-merge issues, such as ensuring that bugs and
> regressions get fixed by someone?
> If so, how do we ensure that people get credit for the roles that they
> assume? Should we perhaps add additional entries to the MAINTAINERS file
> for some of these responsibilities?
> 
Having more than one maintainer works well for the hwmon subsystem. It is a good
way to "train" new maintainers.

I don't like the idea of formalizing maintainer's responsibilities, and I don't
see the need to do it. It should be up to the maintainers to decide and work out
which role to take; there are multiple ways to split the work, roles may change
over time, and the maintainers are the best to decide what their role should be.

And when it comes to architects, my personal opinion is that every architect
should also implement code, to not forget what it actually takes to do it.

Thanks,
Guenter
