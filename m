Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab2DXCQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 22:16:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51286 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab2DXCP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 22:15:59 -0400
Date: Tue, 24 Apr 2012 10:16:00 +0800
From: Wang YanQing <udknight@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Anil Nair <anilcoll90@gmail.com>, Greg KH <greg@kroah.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [RFC]Is usb port number fixed?
Message-ID: <20120424021600.GA5283@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Anil Nair <anilcoll90@gmail.com>, Greg KH <greg@kroah.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <20120423015212.GA7547@udknight>
 <Pine.LNX.4.44L0.1204231109380.1612-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204231109380.1612-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 11:13:06AM -0400, Alan Stern wrote:
> The port numbers are determined by the hardware -- each set of wires
> has its own port number.  The numbers have nothing to do with
> bandwidth.
Could you figure out the codes in kernel that read out the port number from
hub, if there is a piece of codes do that things?

Thanks very much.
