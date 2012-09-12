Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2ILSay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:30:54 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48047 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2ILSaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:30:52 -0400
Date: Wed, 12 Sep 2012 15:30:44 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2012-09-08
Message-ID: <20120912183044.GA28232@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20120908215956.GP5788@joana>
 <20120912181309.GB28823@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912181309.GB28823@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

* John W. Linville <linville@tuxdriver.com> [2012-09-12 14:13:10 -0400]:

> On Sat, Sep 08, 2012 at 06:59:56PM -0300, Gustavo Padovan wrote:
> > Hi John,
> > 
> > A few more fixes to 3.6, here we have four important fix to the MGMT interface,
> > two from Johan Hedberg and Andrzej Kaczmarek. Andrei fixed a free on
> > uninitialized memory and I added support for Broadcom/Foxconn devices.
> 
> "Bluetooth: mgmt: Implement support for passkey notification" doesn't
> look like a fix at all.

It is a fix in the sense that we were failing to work with some keyboards out
there that only support Bluetooth SSP KeyboardOnly IO capability and there are
few of those in the market now. But yes, we are not fix any crash, etc in the
kernel, not critical though. It is just improving compatibility of the
Bluetooth stack (which is important too). It's up to you merge this or not.

> 
> "Bluetooth: Update management interface revision" is suspect.  It kinda
> makes sense, but if it is so important than it should have been merged
> much earlier, no?

Not really, but we like to bump version when we do significative changes to
MGMT like the above.

> 
> "Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for Broadcom/Foxconn"
> might normally be OK, but it is getting late enough in the cycle
> that I would prefer to delay any device ID patches until the next
> merge window.

Ok.

> 
> The others look fine.  Do you want me to merge them directly?
> Or would you rather respin your pull request?

You can pull them directly, I'll redo my tree once they get pulled.
Thanks, John.  

	Gustavo
