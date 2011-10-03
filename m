Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab1JCU3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:29:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:53453 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1JCU3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:29:05 -0400
Date: Mon, 3 Oct 2011 22:28:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: xen: IPI interrupts not resumed early enough on suspend/resume
In-Reply-To: <201110032202.24237.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.02.1110032228390.1489@ionos>
References: <1317654626.21903.72.camel@zakaz.uk.xensource.com> <alpine.LFD.2.02.1110032033530.1489@ionos> <201110032202.24237.rjw@sisk.pl>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Rafael J. Wysocki wrote:
> On Monday, October 03, 2011, Thomas Gleixner wrote:
> > We already shut down the nonboot cpus on suspend. We could do that
> > _before_ we disable devices and the interrupts.
> >  
> > Raphael ?
> 
> I'm afraid that wouldn't work.  At least right now our suspend sequence is
> reasonably in line with what ACPI says.
> 
> Besides, we suspend devices in parallel now, so that would be going backwards
> a bit.

Fair enough.
