Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab0GMDg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 23:36:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41503
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753168Ab0GMDg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 23:36:56 -0400
Date: Mon, 12 Jul 2010 20:37:11 -0700 (PDT)
Message-Id: <20100712.203711.84385391.davem@davemloft.net>
To: James.Bottomley@suse.de
Cc: joe@perches.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@suse.de, matthew@wil.cx, linux-scsi@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/scsi: Remove warnings after vsprintf
 %pV introduction
From: David Miller <davem@davemloft.net>
In-Reply-To: <1278923239.32614.1.camel@mulgrave.site>
References: <1278824921.1501.37.camel@Joe-Laptop.home>
	<20100710.231026.233698429.davem@davemloft.net>
	<1278923239.32614.1.camel@mulgrave.site>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@suse.de>
Date: Mon, 12 Jul 2010 04:27:18 -0400

> What's the other 60% of the patch about? the strange addition of
> scsi_show_extd_sense_args() and all the KERN_CONT bits?

Well the new function is for logical seperation, and KERN_CONT
is what is supposed to be at the front of every printk format
that continues a partially-printed line.
