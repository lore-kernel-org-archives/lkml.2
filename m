Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab2GIQoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 12:44:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39382 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413Ab2GIQoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 12:44:04 -0400
X-Sasl-enc: 61vP3dEYB9F5WxSF3OxL/HPKd9QJV/opkW0/dQ3SAC/w 1341852243
Date: Mon, 9 Jul 2012 09:44:02 -0700
From: Greg KH <greg@kroah.com>
To: Shachar Shemesh <shachar@liveu.tv>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Subject: [PATCH] tty ldisc: Close/Reopen race prevention should
 check the proper flag
Message-ID: <20120709164402.GA14592@kroah.com>
References: <4FEFF3DF.9000909@liveu.tv>
 <20120706212430.GA454@kroah.com>
 <4FF94BC6.3000704@liveu.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF94BC6.3000704@liveu.tv>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2012 at 11:58:46AM +0300, Shachar Shemesh wrote:
> On 07/07/2012 12:24 AM, Greg KH wrote:
> >On Sun, Jul 01, 2012 at 09:53:19AM +0300, Shachar Shemesh wrote:
> >>From: Shachar Shemesh <shachar@liveu.tv>
> >>
> >>Commit acfa747b introduced the TTY_HUPPING flag to distinguish
> >>closed TTY from currently closing ones. The test in tty_set_ldisc
> >>still remained pointing at the old flag. This causes pppd to
> >>sometimes lapse into uninterruptible sleep when killed and
> >>restarted.
> >>
> >>Signed-off-by: Shachar Shemesh <shachar@liveu.tv>
> >>---
> >>Tested with 3.2.20 kernel.
> >>
> >All tabs are converted to spaces and make this patch impossible to apply
> >:(
> >
> >Care to try again?
> I'm sorry, I'm sending this as an attachment. I've verified that my
> mailer sends this as plain text, so it should be okay.

Yes, that worked, but then I would have to edit the body to include the
above information in the patch properly.

So, care to resend it all in a "clean" format that I can apply it in?

thanks,

greg k-h
