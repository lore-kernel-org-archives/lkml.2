Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2DUF5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 01:57:35 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59036 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2DUF5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 01:57:33 -0400
Date: Sat, 21 Apr 2012 13:56:59 +0800
From: Wang YanQing <udknight@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [RFC]Is usb port number fixed?
Message-ID: <20120421055658.GA5277@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <20120420153727.GA29331@kroah.com>
 <Pine.LNX.4.44L0.1204202028250.19313-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204202028250.19313-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 08:32:37PM -0400, Alan Stern wrote:
> In this particular case, it is guaranteed that the left USB port will 
> always be numbered as X-1.1:1.0 and the right port as X-1.2:1.0, where 
> the number X may change from one boot to another.  But the -1.1:1.0 and 
> -1.2:1.0 parts will always be the same.
> 
> This is because X is the bus number, which is allowed to change.  The 
> -1.1:1.0 and -1.2:1.0 values are port, configuration, and interface 
> numbers.  They will never change, because they come from the hardware.
Yes, configuration and interface come from the hardware,
but I don't know where the port come from, at least I don't think the port
comes from the same hardware with the configuration and interface, do you 
mean port come from the hub?
