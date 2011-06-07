Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab1FGNpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:45:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46067 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754290Ab1FGNp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:45:29 -0400
Date: Tue, 7 Jun 2011 09:45:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v15 10/10] usb:dummy_hcd: Force FS device connection
 according to module parameter
In-Reply-To: <014201cc24cf$1b3414d0$519c3e70$@org>
Message-ID: <Pine.LNX.4.44L0.1106070941580.1972-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, Tanya Brokhman wrote:

> > You might want to print out some kind of error message if the user
> > specifies is_super_speed = True and is_high_speed = False.
> > 
> 
> I thought about that as well. Even added it but removed at the last minute
> :) I encountered quite a few places in the code where some error message to
> the user is really needed but is missing

What other places?  There is very little the user has to do with 
dummy-hcd -- really nothing more than setting the module parameters.

>  so my impression was that it's best
> to keep the printks to a minimum. Isn't that the general approach? IMO, in
> this particular case informing the user isn't a "must". If you feel strongly
> about it I can add the message.

IMO the driver should print an error message and fail to load if there 
are contradictory module parameters.

Alan Stern

