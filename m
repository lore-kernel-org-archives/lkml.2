Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab2K0SYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:24:11 -0500
Received: from smtp3.newsguy.com ([74.209.136.66]:63660 "EHLO
	smtp3.newsguy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab2K0SYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:24:10 -0500
X-Greylist: delayed 779 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2012 13:24:10 EST
Message-ID: <50B5024C.3030907@newsguy.com>
Date: Tue, 27 Nov 2012 10:11:24 -0800
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120915 Thunderbird/10.0.6
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Nathan Williams <nathan@traverse.com.au>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH] mtd cs553x_nand: Initialise ecc.strength before nand_scan()
References: <1353541372.12585.14.camel@laptop> <CAN8TOE-10VYTOS8EbPWxs0HyhdeZBzxL_8gmJsMmXPO1ti_6bQ@mail.gmail.com>
In-Reply-To: <CAN8TOE-10VYTOS8EbPWxs0HyhdeZBzxL_8gmJsMmXPO1ti_6bQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 08:08 PM, Brian Norris wrote:
> On Wed, Nov 21, 2012 at 3:42 PM, Nathan Williams <nathan@traverse.com.au> wrote:
>> Loading cs553x_nand with Hynix H27U1G8F2BTR NAND flash causes this bug:
>>
>> kernel BUG at drivers/mtd/nand/nand_base.c:3345!
> ...
>> Initialising ecc.strength before the call to nand_scan() fixes this.
> 
> Acked-by: Brian Norris <computersforpeace@gmail.com>


Acked-by: Mike Dunn <mikedunn@newsguy.com>


> 
> BTW, I made a quick read through of the other NAND drivers to look for
> similar errors. I think this is the only one where the only
> ecc.strenght initialization occurred after the nand_scan() or
> nand_scan_tail() call.


Thanks for that Brian.  I thought I did this when another driver had a similiar
problem a while back.  Maybe I just intended to :(

Mike
