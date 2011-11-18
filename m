Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab1KRJ1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:27:24 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:55219 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab1KRJ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:27:22 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Dan Delaney <drdelaney@loclhst.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbled: add support for Dream Cheeky DL100B Mailbox Friends Alert (1d34:000a)
Date: Fri, 18 Nov 2011 10:28:24 +0100
User-Agent: KMail/1.13.5 (Linux/3.1.0-rc9-12-desktop+; KDE/4.4.4; x86_64; ; )
References: <4EC60E9D.6070606@loclhst.com>
In-Reply-To: <4EC60E9D.6070606@loclhst.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111181028.24153.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 18. November 2011, 08:51:57 schrieben Sie:
> This patch will add support for the Dream Cheeky Mailbox Friends Alert (http://www.dreamcheeky.com/mailbox-friends-alert) usb led dongle.
> The drivers for the webmail notifier (1d34:0004) work perfectly fine, so I just would like to add support for the new device.
> I have tested the patch on gentoo sources of 2.6.39 and 3.0.6, as well as vanilla 3.1.1 and 3.2-rc2.
> 
> This is my first attempt at making a change to the kernel, so let me know if I need to change something (formatting, where to post, etc)
> 
> I am not sure who else I may need to CC on this.

Please cc this to

greg@kroah.com
linux-usb@vger.kernel.org

In addition you need to add a "Signed-off-by" line as described in
Documentation/SubmittingPatches in the kernel tree.

	HTH
		Oliver
