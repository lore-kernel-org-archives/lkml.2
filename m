Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507Ab0FBR0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 13:26:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52368
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758035Ab0FBR0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 13:26:41 -0400
Date: Wed, 02 Jun 2010 10:26:50 -0700 (PDT)
Message-Id: <20100602.102650.56364159.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: fthain@telegraphics.com.au, joe@perches.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] net: mac8390 - Sort out memory/MMIO accesses and casts
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTilqknhgBCXd-5Yxj9U8gDzDfMmmZdwDOvf-8kbH@mail.gmail.com>
References: <alpine.OSX.2.00.1005290312230.691@localhost>
	<AANLkTilLXOSb2P_m4uUubmJar2VMFXizzpa_mQ1j8GPz@mail.gmail.com>
	<AANLkTilqknhgBCXd-5Yxj9U8gDzDfMmmZdwDOvf-8kbH@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 2 Jun 2010 19:24:08 +0200

> On Sat, May 29, 2010 at 10:03, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Fri, May 28, 2010 at 19:21, Finn Thain <fthain@telegraphics.com.au> wrote:
>>> On Sun, 23 May 2010, Geert Uytterhoeven wrote:
>>>> >> But here's a better solution. I do not have the hardware to test it,
>>>> >> though. Finn, does it {look OK,work}?
>>>> >
>>>> > It looks fine. I can't test it right now, but I will do so when I get
>>>> > the opportunity.
>>>>
>>>> Any news from the test front?
>>>
>>> This is commit ba0f916ca7ac79356e2ed32a85c3aa8255b104e7, right?
>>
>> Yep.
>>
>>> If so, it tests OK here.
>>
>> Thanks for testing!
> 
> David, will you take this one too?

Please post a fresh copy, there is no way that sucker still applies cleanly
as there have been some changes in this area recently.

Thanks.
