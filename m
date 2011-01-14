Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1ANFuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:50:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49946
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884Ab1ANFuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:50:01 -0500
Date: Thu, 13 Jan 2011 21:50:34 -0800 (PST)
Message-Id: <20110113.215034.20934534.davem@davemloft.net>
To: jj@chaosbits.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ramkrishna.vepa@exar.com, jon.mason@exar.com,
        sivakumar.subramani@exar.com, sreenivasa.honnur@exar.com
Subject: Re: [PATCH] vxge: Remember to release firmware after upgrading
 firmware
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1101132119080.11347@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101132119080.11347@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Thu, 13 Jan 2011 21:25:20 +0100 (CET)

> Regardless of whether the firmware update being performed by 
> vxge_fw_upgrade() is a success or not we must still remember to always 
> release_firmware() before returning.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.
