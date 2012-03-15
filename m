Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161361Ab2COUGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:06:06 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58773 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161052Ab2COUGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:06:03 -0400
Date: Thu, 15 Mar 2012 21:05:57 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pete Zaitcev <zaitcev@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/ub: deprecate & schedule for removal the "Low
 Performance USB Block" driver
Message-ID: <20120315200557.GA6123@breakpoint.cc>
References: <20120315175701.GA5702@breakpoint.cc>
 <Pine.LNX.4.44L0.1203151601070.1366-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1203151601070.1366-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 04:03:02PM -0400, Alan Stern wrote:
> Pete wasn't talking about the phrase "holds various workarounds...".  
> Rather, he was referring to the phrase "does not use libusual".  That
> part is wrong; ub _does_ use libusual.

Okay, so I mixed up those two. "does not use libunsual" would be the correct
thing to day, right?

> Alan Stern

Sebastian
