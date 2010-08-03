Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0HCPec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:34:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46610 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754125Ab0HCPeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:34:31 -0400
Date: Tue, 3 Aug 2010 11:34:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Valdis.Kletnieks@vt.edu
cc: "Justin P. Mattock" <justinmattock@gmail.com>, <linux-usb@vger.kernel.org>,
        <dbrownell@users.sourceforge.net>, <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2]drivers/usb/core/sysfs.c Fix variable 'retval' set
 but not used
In-Reply-To: <66093.1280848412@localhost>
Message-ID: <Pine.LNX.4.44L0.1008031133270.1853-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010 Valdis.Kletnieks@vt.edu wrote:

> > Failure to create a file in sysfs is almost never fatal and usually not 
> > even dangerous.  Ignoring the error is generally better than failing 
> > the entire operation.
> 
> Then why the __must_check attribute if it's usually ignorable? I thought
> that was reserved for functions that you damned sight better well check
> for errors because bad things are afoot otherwise?

That's a good question.  Perhaps Greg KH knows the answer.

Alan Stern

