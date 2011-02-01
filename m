Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1BASkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:40:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33266 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab1BASkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:40:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
Date: Tue, 1 Feb 2011 19:39:49 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>
References: <201101300107.19389.rjw@sisk.pl> <201102011158.46312.rjw@sisk.pl> <87sjw7wvjl.fsf@ti.com>
In-Reply-To: <87sjw7wvjl.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102011939.49793.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 01, 2011, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> [...]
> 
> > Also, I'm going to move the power domain hook to the struct device level, so
> > that we have:
> >
> > struct device {
> >     ...
> >     struct power_domain *domain;
> >     ...
> > };
> >
> > struct power_domain {
> >     struct dev_pm_ops ops;
> > };
> >
> 
> Great, thanks.
> 
> Any opinion on my idea to name this 'struct dev_power_domain' to avoid
> confusion with existing powerdomain structs in SoC code?  For example,
> on OMAP we already have a 'struct powerdomain'.

Fine by me.

Thanks,
Rafael
