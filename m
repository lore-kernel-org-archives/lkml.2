Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1AYHUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 02:20:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57192
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233Ab1AYHUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 02:20:01 -0500
Date: Mon, 24 Jan 2011 23:20:35 -0800 (PST)
Message-Id: <20110124.232035.183057878.davem@davemloft.net>
To: jj@chaosbits.net
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, gregkh@suse.de, zapman@interlan.net,
        rothwell@interlan.net
Subject: Re: [PATCH] USB NET KL5KUSB101: Fix mem leak in error path of
 kaweth_download_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1101232315230.30955@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101232315230.30955@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 23 Jan 2011 23:19:55 +0100 (CET)

> We will leak the storage allocated by request_firmware() if the size of 
> the firmware is greater than KAWETH_FIRMWARE_BUF_SIZE.
> This removes the leak by calling release_firmware() before we return 
> -ENOSPC.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks Jesper.
