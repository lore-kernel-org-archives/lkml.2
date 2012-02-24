Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab2BXNyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:54:04 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:49781 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab2BXNyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:54:01 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Danny Kukawka <danny.kukawka@bisect.de>
Subject: Re: [PATCH 09/11] usb/kaweth: print MAC via printk format specifier
Date: Fri, 24 Feb 2012 14:56:37 +0100
User-Agent: KMail/1.13.5 (Linux/3.3.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Danny Kukawka <dkukawka@suse.de>, linux-usb@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de> <1330091162-8141-10-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1330091162-8141-10-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202241456.37306.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 24. Februar 2012, 14:46:00 schrieb Danny Kukawka:
> Print MAC/dev_addr via printk extended format specifier %pM
> instead of custom code.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Acked-by: Oliver Neukum <oliver@neukum.name>
