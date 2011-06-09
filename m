Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1FIVXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:23:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56447 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752870Ab1FIVXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:23:10 -0400
Date: Thu, 9 Jun 2011 17:23:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] usb:dummy_hcd: Force FS device connection according
 to module parameter
In-Reply-To: <027301cc26e7$b5c99690$215cc3b0$@org>
Message-ID: <Pine.LNX.4.44L0.1106091721240.1914-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011, Tanya Brokhman wrote:

> > > +	if (!mod_data.is_high_speed && mod_data.is_super_speed)
> > > +		return -EINVAL;
> > 
> > Print an error message in the log so that the user will know why the
> > failure occurred.
> > 
> 
> But when the module fails to load the message sais that it's invalid
> parameter (or something like that). That's why I thought it will be enough. 

Oh yes, that's true.

> You mean to add something that explains WHY these values are wrong?

That's what I had in mind.  But "invalid parameter" is probably good 
enough, since these are the _only_ parameters.  :-)  So this part is 
okay as it stands.

Alan Stern

