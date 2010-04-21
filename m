Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab0DUBGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 21:06:32 -0400
Received: from mail.perches.com ([173.55.12.10]:1582 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab0DUBGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 21:06:31 -0400
Subject: Re: [PATCH] Staging: batman-adv: fix checkpath.pl issues
From: Joe Perches <joe@perches.com>
To: Mikal Sande <mikal.sande@gmail.com>
Cc: andrew@lunn.ch, lindner_marek@yahoo.de, gregkh@suse.de,
       siwu@hrz.tu-chemnitz.de, sdietrich@novell.com, sven.eckelmann@gmx.de,
       linus.luessing@web.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1271810978.14405.14.camel@pondus>
References: <1271810978.14405.14.camel@pondus>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 18:06:28 -0700
Message-ID: <1271811988.1730.244.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 02:49 +0200, Mikal Sande wrote:
> @@ -212,7 +212,9 @@ ssize_t bat_device_write(struct file *file, const char __user *buff,
>  	unsigned long flags;
>  
>  	if (len < sizeof(struct icmp_packet)) {
> -		bat_dbg(DBG_BATMAN, "batman-adv:Error - can't send packet from char device: invalid packet size\n");
> +		bat_dbg(DBG_BATMAN, "batman-adv:" +
> +			"Error - can't send packet from char device: " +
> +			"invalid packet size\n");

C doesn't use + for string concatenation.
Please compile test your changes before submitting them.


