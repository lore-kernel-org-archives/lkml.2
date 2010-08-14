Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab0HNAXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 20:23:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57597 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756416Ab0HNAXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 20:23:43 -0400
Date: Fri, 13 Aug 2010 20:23:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv8 04/13] USB: gadget: mass_storage: moved strings handling
 code to composite
In-Reply-To: <920296.5376.qm@web180304.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.1008132019440.23591-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010, David Brownell wrote:

> --- On Fri, 8/13/10, Alan Stern <stern@rowland.harvard.edu> wrote:
> . 
> > ... based on all
> > the preceding discussion, I now think the best
> > approach may be _never
> > to make up a fake serial number.  Use the module
> > parameter, if any, and
> > otherwise issue a warning and don't have
> > a serial number string
> > descriptor (even though that violates the spec).
> 
> 
> Agreed, and that's what I had asked for.  I didn't
> see code faking up a serial ... did I miss such?

That code has been present in g_file_storage since the beginning.  
There were some patches earlier which moved the code to a different
location.  I guess you missed it.  The current round of patches doesn't
touch that code.

> If so, let's see a new patch with no faking.

An extra patch or two would be needed to remove the fake-serial
generation.

Alan Stern

