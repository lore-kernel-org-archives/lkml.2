Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2DPQlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:41:52 -0400
Received: from bar.sig21.net ([80.81.252.164]:54532 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab2DPQlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:41:51 -0400
Date: Mon, 16 Apr 2012 18:41:39 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Jason Baron <jbaron@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: ehci dynamic debug problem
Message-ID: <20120416164139.GA14077@sig21.net>
References: <20120413174107.GA6021@sig21.net>
 <Pine.LNX.4.44L0.1204131411010.1166-100000@iolanthe.rowland.org>
 <20120413190311.GA6238@sig21.net>
 <20120416155423.GB2345@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416155423.GB2345@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 11:54:24AM -0400, Jason Baron wrote:
> On Fri, Apr 13, 2012 at 09:03:11PM +0200, Johannes Stezenbach wrote:
> > 
> >   Does dynamic debug offer an "is the message two lines below enabled" test?
> > 
> 
> Sorry was away for a bit...
> 
> dynamic debug doesn't offer any is enabled test, its hidden from the
> user. That said, in this case, you can delay the printing to the buffer
> with:
...
> +	ehci_dbg (ehci, "%s\n", dbg_port_buf (_buf, sizeof _buf, label, port, status)); \

I think arguments are evaluated before dev_dbg is called so this
won't help.


Thanks
Johannes
