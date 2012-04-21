Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab2DURXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 13:23:19 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45489 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751022Ab2DURXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 13:23:17 -0400
Date: Sat, 21 Apr 2012 13:23:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Wang YanQing <udknight@gmail.com>
cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [RFC]Is usb port number fixed?
In-Reply-To: <20120421055658.GA5277@udknight>
Message-ID: <Pine.LNX.4.44L0.1204211322530.475-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2012, Wang YanQing wrote:

> On Fri, Apr 20, 2012 at 08:32:37PM -0400, Alan Stern wrote:
> > In this particular case, it is guaranteed that the left USB port will 
> > always be numbered as X-1.1:1.0 and the right port as X-1.2:1.0, where 
> > the number X may change from one boot to another.  But the -1.1:1.0 and 
> > -1.2:1.0 parts will always be the same.
> > 
> > This is because X is the bus number, which is allowed to change.  The 
> > -1.1:1.0 and -1.2:1.0 values are port, configuration, and interface 
> > numbers.  They will never change, because they come from the hardware.
> Yes, configuration and interface come from the hardware,
> but I don't know where the port come from, at least I don't think the port
> comes from the same hardware with the configuration and interface, do you 
> mean port come from the hub?

Yes, it does.

Alan Stern

