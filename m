Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1BVTX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:23:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37637
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755152Ab1BVTX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:23:27 -0500
Date: Tue, 22 Feb 2011 11:24:03 -0800 (PST)
Message-Id: <20110222.112403.179931392.davem@davemloft.net>
To: sshtylyov@mvista.com
Cc: shaharh@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jacmet@sunsite.dk, gregkh@suse.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH] USB 10/100 RJ45 Ethernet Network Adapter
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D640C0F.3050703@ru.mvista.com>
References: <20110222140705.GA6055@redhat.com>
	<4D640C0F.3050703@ru.mvista.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sshtylyov@mvista.com>
Date: Tue, 22 Feb 2011 22:18:39 +0300

> Hello.
> 
> Shahar Havivi wrote:
> 
>> The device is very similar to (0x0fe6, 0x8101),
>> And works well with dm9601 driver.
> 
>   You should sign off your patch in order for it to be merged.

He did, see the follow-up patch with subject

[PATCH-v2] Added support for usb ethernet (0x0fe6, 0x9700)
