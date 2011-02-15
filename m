Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1BOVk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 16:40:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48791 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151Ab1BOVkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 16:40:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 1/2] PM: Add support for device power domains
Date: Tue, 15 Feb 2011 22:40:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.44L0.1102142158100.17345-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102142158100.17345-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102152240.03077.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 15, 2011, Alan Stern wrote:
> On Mon, 14 Feb 2011, Rafael J. Wysocki wrote:
> 
> > > I don't have a clear picture of how people are going to want to use 
> > > these dev_power_domain structures.  Should there be a
> > > 
> > > 	void			*priv;
> > > 
> > > member as well?
> > 
> > Well, I'm not sure.  What would be the purpose of it?
> 
> It's easy to imagine an SoC with multiple power domains and hence
> multiple structures.  The platform code would need some way to tell
> those structures apart.  But we should get some advice from the people
> who will actually have to use these things...

Well, anyway I think it should be easy to add a priv pointer at any time later
if there's a use case?

Rafael
