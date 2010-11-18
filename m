Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab0KRQOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:14:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49256
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932306Ab0KRQOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:14:07 -0500
Date: Thu, 18 Nov 2010 08:14:31 -0800 (PST)
Message-Id: <20101118.081431.226772232.davem@davemloft.net>
To: petkan@nucleusys.com
Cc: joe@perches.com, trivial@kernel.org, petkan@users.sourceforge.net,
        gregkh@suse.de, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] drivers/net/usb: Remove unnecessary casts of
 netdev_priv
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.1011180918420.2169@bender.nucleusys.com>
References: <alpine.DEB.2.00.1011161958320.1392@gabi>
	<20101117.104555.246530412.davem@davemloft.net>
	<alpine.DEB.2.00.1011180918420.2169@bender.nucleusys.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>
Date: Thu, 18 Nov 2010 09:24:49 +0200 (EET)

> On Wed, 17 Nov 2010, David Miller wrote:
> 
>> Also, please use a properly formed "Acked-by: " tag if you want
>> your ACK to actually show up in the commit log message.
> 
> My "ack" was only a notification that i've checked the patch.  It was
> not meant to go into the logs.

The fact that a developer has checked the patch is important and
useful information, so I find it strange that you would want to elide
that record from the commit message. :-)
