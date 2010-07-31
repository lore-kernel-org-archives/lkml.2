Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0GaG2I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 02:28:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33807
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151Ab0GaG2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 02:28:05 -0400
Date: Fri, 30 Jul 2010 23:28:22 -0700 (PDT)
Message-Id: <20100730.232822.59674331.davem@davemloft.net>
To: jon.mason@exar.com
Cc: joe@perches.com, Ramkrishna.Vepa@exar.com, Sreenivasa.Honnur@exar.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net/vxge/vxge-main.c: Use pr_<level>
 and netdev_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100728032117.GL28630@exar.com>
References: <1280267223.24054.44.camel@Joe-Laptop.home>
	<20100728032117.GL28630@exar.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Mason <jon.mason@exar.com>
Date: Tue, 27 Jul 2010 22:21:18 -0500

> On Tue, Jul 27, 2010 at 02:47:03PM -0700, Joe Perches wrote:
>> Use pr_fmt, pr_<level> and netdev_<level> where appropriate.
>> 
>> Signed-off-by: Joe Perches <joe@perches.com>
> 
> Acked-by: Jon Mason <jon.mason@exar.com>

Applied.
