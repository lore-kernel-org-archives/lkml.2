Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab0CaBcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 21:32:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55252
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755324Ab0CaBcT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 21:32:19 -0400
Date: Tue, 30 Mar 2010 18:32:19 -0700 (PDT)
Message-Id: <20100330.183219.40571153.davem@davemloft.net>
To: mashirle@us.ibm.com
Cc: thomas@mathtm.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next-next-2.6 v2] virtio_net: missing sg_init_table
From: David Miller <davem@davemloft.net>
In-Reply-To: <1269911955.14013.4.camel@localhost.localdomain>
References: <1269887518.13277.13.camel@localhost.localdomain>
	<4BB10010.5060505@mathtm.de>
	<1269911955.14013.4.camel@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shirley Ma <mashirle@us.ibm.com>
Date: Mon, 29 Mar 2010 18:19:15 -0700

> Add missing sg_init_table for sg_set_buf in virtio_net which
> induced in defer skb patch.
> 
> Reported-by: Thomas Müller <thomas@mathtm.de>
> Tested-by: Thomas Müller <thomas@mathtm.de>
> Signed-off-by: Shirley Ma <xma@us.ibm.com>

Applied, thanks.
