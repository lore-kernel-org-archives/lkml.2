Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1FFSru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:47:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60424 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab1FFSrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:47:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/5] PM / Runtime: Support for generic I/O power domains (v4)
Date: Mon, 6 Jun 2011 20:48:31 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201104290154.12966.rjw@sisk.pl> <201105280117.17883.rjw@sisk.pl> <Pine.LNX.4.64.1106020920360.4067@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1106020920360.4067@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106062048.31663.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 02, 2011, Guennadi Liakhovetski wrote:
> On Sat, 28 May 2011, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Introduce common headers, helper functions and callbacks allowing
> > platforms to use simple generic power domains for runtime power
> > management.
> > 
> > Introduce struct generic_power_domain to be used for representing
> > power domains that each contain a number of devices and may be
> > master domains or subdomains with respect to other power domains.
> > Among other things, this structure includes callbacks to be
> > provided by platforms for performing specific tasks related to
> > power management (i.e. ->stop_device() may disable a device's
> > clocks, while ->start_device() may enable them, ->power_off() is
> > supposed to remove power from the entire power domain
> > and ->power_on() is supposed to restore it).
> 
> I've got a generic question to this: do we have any examples of 
> power-domain specific ->start_device() and ->stop_device() callbacks? A 
> common case is, when these callbacks start and stop clocks, associated 
> with the device, but this is not power-domain specific, right? Do we have 
> any examples of different power domains in a system, having different 
> these calbacks, but all devices in one power-domain, having the same ones?

No, we don't have any at the moment.

Thanks,
Rafael
