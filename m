Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423116Ab2JaPHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:07:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43447 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1423019Ab2JaPHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:07:45 -0400
Date: Wed, 31 Oct 2012 11:07:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb/gadget: let file storage gadget select libcomposite
In-Reply-To: <xa1tfw4ug5so.fsf@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1210311106530.1954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Michal Nazarewicz wrote:

> On Wed, Oct 31 2012, Felipe Balbi <balbi@ti.com> wrote:
> > nevertheless, I should be receiving a patch right about now removing
> > that file. Alan, care to send a patch for that ?
> 
> I have some other stuff to remove as well, so I can take care of it, so
> Alan can spend his time on something more important.

I'm happy to have Michal remove g_file_storage.  That way, he gets to 
deal with any complaints.  :-)

Alan Stern

