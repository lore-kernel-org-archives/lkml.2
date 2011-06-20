Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1FTSqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 14:46:33 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34715 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1FTSqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 14:46:31 -0400
Message-ID: <4DFF9568.8030704@ahsoftware.de>
Date: Mon, 20 Jun 2011 20:46:00 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Nicolas Pitre <nico@fluxnic.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
References: <Pine.LNX.4.44L0.1106201436430.2113-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106201436430.2113-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.06.2011 20:39, schrieb Alan Stern:
> On Mon, 20 Jun 2011, Alexander Holler wrote:
>
>> I see it that way: packed is needed to be sure that at least for struct
>> ehci_regs there are no padding bytes inbetween the members.
>
> But is it _really_ needed?
>
>> It might
>> work without, but that depends on the compiler (-version, architecture,
>> whatever).
>
> Have there _ever_ been _any_ combinations of compiler, version,
> architecture, whatever, that had unwanted padding bytes in this
> structure?

I don't know. But if there would be no doubts, this discussion would not 
happen and I assume there never would have been an attribute packed there.

Regards,

Alexander
