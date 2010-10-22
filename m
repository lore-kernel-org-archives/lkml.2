Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab0JVV2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:28:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43984 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757089Ab0JVV2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:28:07 -0400
Date: Fri, 22 Oct 2010 17:28:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Luben Tuikov <ltuikov@yahoo.com>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [USB] Use normalized sense when emulating autosense
In-Reply-To: <177615.57592.qm@web31810.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.1010221726530.4510-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, Luben Tuikov wrote:

> --- On Fri, 10/22/10, Alan Stern <stern@rowland.harvard.edu> wrote:
> > What about the Filemark and ILI tests?  You mustn't
> > get rid of them; 
> > they are needed for tape drives.
> 
> I've resubmitted the patch.

Yeah, the new one is better.  I would have preferred to see fm_ili 
explained in a comment, but this is okay.

Alan Stern

