Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1B1IbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 03:31:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47555 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1B1IbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 03:31:05 -0500
Date: Mon, 28 Feb 2011 01:31:00 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Greg KH <greg@kroah.com>
Cc: Tobias Klauser <tklauser@distanz.ch>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-serial@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 v3] tty: serial: altera_uart: Add devicetree support
Message-ID: <20110228083100.GE13690@angua.secretlab.ca>
References: <c7a7085602687d2f1b6ac505c030f19bafda04e3.1297245277.git.tklauser@distanz.ch>
 <1298025332-31846-1-git-send-email-tklauser@distanz.ch>
 <20110225175856.GA17072@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225175856.GA17072@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 09:58:56AM -0800, Greg KH wrote:
> On Fri, Feb 18, 2011 at 11:35:32AM +0100, Tobias Klauser wrote:
> > With the recent switch of the (currently still out-of-tree) Nios2 Linux
> > port to devicetree we want to be able to retreive the resources and
> > properties from dts.
> > 
> > The old method to retreive resources and properties from platform data
> > is still supported.
> > 
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> > ---
> > 
> > Greg: This patch will have the same compile problem in your tree as the
> > altera_jtaguart patch has. As this patch depends on the previous ones of
> > this series it might be best to apply it once commit c9e358dfc
> > "driver-core: remove conditionals around devicetree pointers" from
> > Grant's tree is merged.
> 
> Ok, I can't take this then, Grant, can you?
> 
> Please feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to it.

Merged, thanks,

g.

