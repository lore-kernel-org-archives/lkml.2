Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1IRIcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 04:32:47 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:32936 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753Ab1IRIcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 04:32:45 -0400
X-Sasl-enc: Ni5dUy7IjFzv0PDlJBPnoS5TtPiaj7e7v2fpgATV5ApE 1316334762
Date: Sun, 18 Sep 2011 01:26:26 -0700
From: Greg KH <greg@kroah.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Shaun Kluzek <g0del@bigpond.com>, gregkh@suse.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB GADGET: u_serial.c: fixed a brace and whitespace
 coding style issue
Message-ID: <20110918082626.GA19444@kroah.com>
References: <20110831072254.GA9706@epione>
 <4E5F8053.4080603@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5F8053.4080603@ru.mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 04:53:39PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 31-08-2011 11:22, Shaun Kluzek wrote:
> 
> >Signed-off-by: Shaun Kluzek<g0del@bigpond.com>
> >---
> >  drivers/usb/gadget/u_serial.c |    5 +----
> >  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> >diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
> >index a8aa469..b86022f 100644
> >--- a/drivers/usb/gadget/u_serial.c
> >+++ b/drivers/usb/gadget/u_serial.c
> >@@ -552,11 +552,8 @@ recycle:
> >  	/* Push from tty to ldisc; without low_latency set this is handled by
> >  	 * a workqueue, so we won't get callbacks and can hold port_lock
> >  	 */
> >-	if (tty && do_push) {
> >+	if (tty && do_push)
> >  		tty_flip_buffer_push(tty);
> >-	}
> >-
> 
>    What's wrong with the first empty line here?
> 
> >-

I agree, don't delete all of the spacing here.

greg k-h
