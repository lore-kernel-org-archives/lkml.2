Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760Ab0HMPPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 11:15:19 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45104 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761665Ab0HMPPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 11:15:17 -0400
Date: Fri, 13 Aug 2010 11:15:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv8 04/13] USB: gadget: mass_storage: moved strings handling
 code to composite
In-Reply-To: <449572.54202.qm@web180316.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.1008131110130.12397-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010, David Brownell wrote:

> Looks OK, but I can't test or give it
> a detailed review just now.  An ACK from
> Alan would be nice.

There's nothing obviously wrong with this change.  However based on all
the preceding discussion, I now think the best approach may be _never_
to make up a fake serial number.  Use the module parameter, if any, and
otherwise issue a warning and don't have a serial number string
descriptor (even though that violates the spec).

At this point it should be easy to write a patch to implement and
document the new behavior, for both file-storage and mass-storage.

Alan Stern

