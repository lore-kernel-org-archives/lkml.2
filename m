Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1LMUFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:05:05 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61970 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1LMUFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:05:02 -0500
MIME-Version: 1.0
In-Reply-To: <20111212194445.GG32251@atomide.com>
References: <20111207193141.GG31337@atomide.com>
	<1323287816-2809-1-git-send-email-felipe.contreras@gmail.com>
	<20111208144044.GA25415@xps8300>
	<CAMP44s2noD4TXBALOc0JkcbVroYFnp3BaSozrQYdUbsv50xuoQ@mail.gmail.com>
	<20111212194445.GG32251@atomide.com>
Date: Tue, 13 Dec 2011 22:05:01 +0200
Message-ID: <CAMP44s301iWcReReqScJw+N1pQ4=g8D8hZKOV3wEX-qN0_gRQQ@mail.gmail.com>
Subject: Re: [PATCH] omap: rx51: initialize isp1704 properly
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Heikki Krogerus <krohei@gmail.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 9:44 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Felipe Contreras <felipe.contreras@gmail.com> [111208 11:52]:
>> On Thu, Dec 8, 2011 at 4:40 PM, Heikki Krogerus <krohei@gmail.com> wrote:
>> > On Wed, Dec 07, 2011 at 09:56:56PM +0200, Felipe Contreras wrote:
>> >> From: Heikki Krogerus <krohei@gmail.com>
>> >
>> > I would prefer that you change this so this is from you, like it
>> > actually is. You can mention me in the commit message if you like.
>>
>> Well, you came with the fix, I just typed it down, but as you wish :)
>>
>> >> Without this USB networking doesn't work as the link is never detected.
>> >
>> > What this changes is, it leaves the transceiver powered by default
>> > instead of setting it into power off mode. So not only USB networking
>> > is affected by this. If isp1704_charger is not enabled with RX51, USB
>> > does not work at all. Please change the comment.
>>
>> I've updated the patch.
>
> Sorry what's the deal with this one? Is this the one to use or is there
> some other patch?

Yeap, there's v2 of this one:
1323375780-13190-1-git-send-email-felipe.contreras@nokia.com

Cheers.

-- 
Felipe Contreras
