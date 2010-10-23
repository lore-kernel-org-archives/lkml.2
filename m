Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab0JWQl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 12:41:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38450 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757366Ab0JWQl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 12:41:58 -0400
Date: Sat, 23 Oct 2010 12:41:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Luben Tuikov <ltuikov@yahoo.com>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [USB] Use normalized sense when emulating autosense
In-Reply-To: <927255.77335.qm@web31804.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.1010231240080.3849-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, Luben Tuikov wrote:

> --- On Fri, 10/22/10, Alan Stern <stern@rowland.harvard.edu> wrote:
> > Yeah, the new one is better.  I would have preferred
> > to see fm_ili 
> > explained in a comment, but this is okay.
> 
> Thanks. I tried to preserve the logic and the comments as much as possible and tried not to introduce neither additional comment nor additional logic. Is this an implicit ACK then? Or does Greg needs an explicit one?  Will he or I have to ask for an explicit ACK? From whom else?

You may consider it an ACK from me.  However this needs to be approved 
by the usb-storage maintainer.

Alan Stern

