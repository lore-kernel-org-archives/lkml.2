Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1FBEMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 00:12:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58910 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1FBEMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 00:12:21 -0400
Date: Wed, 01 Jun 2011 21:11:42 -0700 (PDT)
Message-Id: <20110601.211142.557328157396419857.davem@davemloft.net>
To: metze@samba.org
Cc: oliver@neukum.name, gregkh@suse.de, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbnet/cdc_ncm: add missing .reset_resume hook
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306929701-22861-2-git-send-email-metze@samba.org>
References: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E568@EXDCVYMBSTM006.EQ1STM.local>
	<1306929701-22861-1-git-send-email-metze@samba.org>
	<1306929701-22861-2-git-send-email-metze@samba.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Jun 2011 21:11:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>
Date: Wed,  1 Jun 2011 14:01:41 +0200

> This avoids messages like this after suspend:
> 
>    cdc_ncm 2-1.4:1.6: no reset_resume for driver cdc_ncm?
>    cdc_ncm 2-1.4:1.7: no reset_resume for driver cdc_ncm?
>    cdc_ncm 2-1.4:1.6: usb0: unregister 'cdc_ncm' usb-0000:00:1d.0-1.4, CDC NCM
> 
> This is important for the Ericsson F5521gw GSM/UMTS modem.
> Otherwise modemmanager looses the fact that the cdc_ncm and cdc_acm devices
> belong together.
> 
> The cdc_ether module does the same.
> 
> Signed-off-by: Stefan Metzmacher <metze@samba.org>

Applied and queued up for -stable, thanks.
