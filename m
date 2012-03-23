Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2CWHVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 03:21:43 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:35129 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2CWHVl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 03:21:41 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: Regression due to: net/usbnet: avoid recursive locking in usbnet_stop()
Date: Fri, 23 Mar 2012 08:21:51 +0100
User-Agent: KMail/1.13.5 (Linux/3.3.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <4F6BAE34.7010805@wwwdotorg.org>
In-Reply-To: <4F6BAE34.7010805@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203230821.51870.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 22. März 2012, 23:56:52 schrieb Stephen Warren:
> It looks like commit 4231d47e6fe69f061f96c98c30eaf9fb4c14b96d
> "net/usbnet: avoid recursive locking in usbnet_stop()" causes a problem
> for me.
> 
> When I reboot or shutdown, I see the error spew below at least 50% of
> the time. Reverting the above patch fixes this, at least for 10 reboot
> attempts.

The patch "usbnet: increase URB reference count before usb_unlink_urb" has just been
applied. Could you test whether it fixes your proble?

	Regards
		Oliver
