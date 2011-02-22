Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1BVUTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:19:49 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47637 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1BVUTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:19:47 -0500
Message-ID: <4D641A08.5020607@ru.mvista.com>
Date: Tue, 22 Feb 2011 23:18:16 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sshtylyov@mvista.com, shaharh@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jacmet@sunsite.dk, gregkh@suse.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH] USB 10/100 RJ45 Ethernet Network Adapter
References: <20110222140705.GA6055@redhat.com>	<4D640C0F.3050703@ru.mvista.com> <20110222.112403.179931392.davem@davemloft.net>
In-Reply-To: <20110222.112403.179931392.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David Miller wrote:

>> Shahar Havivi wrote:

>>> The device is very similar to (0x0fe6, 0x8101),
>>> And works well with dm9601 driver.
>>   You should sign off your patch in order for it to be merged.

> He did, see the follow-up patch with subject

> [PATCH-v2] Added support for usb ethernet (0x0fe6, 0x9700)

    Yeah, I've somewhat hasted with following up.

WBR, Sergei
