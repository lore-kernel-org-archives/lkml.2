Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab2CWD2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 23:28:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab2CWD2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 23:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <4F6BAE34.7010805@wwwdotorg.org>
References: <4F6BAE34.7010805@wwwdotorg.org>
Date: Fri, 23 Mar 2012 11:28:20 +0800
Message-ID: <CACVXFVMPqXr+AuoBj9R5Fk=_UOPaozm2ok9zd9N-_JUOe8cu4g@mail.gmail.com>
Subject: Re: Regression due to: net/usbnet: avoid recursive locking in usbnet_stop()
From: Ming Lei <tom.leiming@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 6:56 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> It looks like commit 4231d47e6fe69f061f96c98c30eaf9fb4c14b96d
> "net/usbnet: avoid recursive locking in usbnet_stop()" causes a problem
> for me.
>
> When I reboot or shutdown, I see the error spew below at least 50% of
> the time. Reverting the above patch fixes this, at least for 10 reboot
> attempts.

The two patches[1][2] should fix your problem, please try them.
Both have been applied into David's tree.


[1], http://marc.info/?l=linux-usb&m=133242262312402&w=2
[2], http://marc.info/?l=linux-usb&m=133242264412410&w=2

Thanks,
-- 
Ming Lei
