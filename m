Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab0KOTBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:01:43 -0500
Received: from usmamail.tilera.com ([72.1.168.231]:19398 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997Ab0KOTBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:01:42 -0500
Message-ID: <4CE18394.5060606@tilera.com>
Date: Mon, 15 Nov 2010 14:01:40 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <shemminger@vyatta.com>,
        <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] drivers/net/tile/: on-chip network drivers for the
 tile architecture
References: <4CD1CE62.9010307@tilera.com>	<201011140335.oAE3Zuqg032279@farm-0027.internal.tilera.com>	<20101114075213.GA15495@merkur.ravnborg.org> <20101115.102210.242124777.davem@davemloft.net>
In-Reply-To: <20101115.102210.242124777.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 1:22 PM, David Miller wrote:
> Also please fix the date on your computer, or please change whatever
> it is that makes your patch postings use a date in the past.

Oops!  I put together my email with git format-patch, and edited the
"Reference:" and "In-Reply-To:" headers to point to my previous patch, and
I apparently pulled in the Date field from that previous email as well.  I
think that was likely the only instance of a bad date on patch postings
from me, but I'll be more vigilant going forwards.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

