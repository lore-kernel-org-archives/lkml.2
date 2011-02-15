Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1BODB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 22:01:28 -0500
Received: from netrider.rowland.org ([192.131.102.5]:33928 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751192Ab1BODB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 22:01:26 -0500
Date: Mon, 14 Feb 2011 22:01:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC][PATCH 1/2] PM: Add support for device power domains
In-Reply-To: <201102142334.47553.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1102142158100.17345-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Rafael J. Wysocki wrote:

> > I don't have a clear picture of how people are going to want to use 
> > these dev_power_domain structures.  Should there be a
> > 
> > 	void			*priv;
> > 
> > member as well?
> 
> Well, I'm not sure.  What would be the purpose of it?

It's easy to imagine an SoC with multiple power domains and hence
multiple structures.  The platform code would need some way to tell
those structures apart.  But we should get some advice from the people
who will actually have to use these things...

Alan Stern

