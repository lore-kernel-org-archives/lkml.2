Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab1LUGYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 01:24:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57425 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab1LUGYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 01:24:13 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Minchan Kim" <minchan@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc: remove #ifdef in function body
References: <1324444679-9247-1-git-send-email-minchan@kernel.org>
 <op.v6tsxbmb3l0zgt@mpn-glaptop>
 <20111221062232.GE28505@barrios-laptop.redhat.com>
Date: Wed, 21 Dec 2011 07:24:05 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v6ttefog3l0zgt@mpn-glaptop>
In-Reply-To: <20111221062232.GE28505@barrios-laptop.redhat.com>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 07:22:32 +0100, Minchan Kim <minchan@kernel.org> wrote:

> On Wed, Dec 21, 2011 at 07:13:49AM +0100, Michal Nazarewicz wrote:
>> On Wed, 21 Dec 2011 06:17:59 +0100, Minchan Kim <minchan@kernel.org> wrote:
>> >We don't like function body which include #ifdef.
>> >If we can, define null function to go out compile time.
>> >It's trivial, no functional change.
>>
>> It actually adds “flush_tlb_kenel_range()” call to the function so there
>> is functional change.
>
> Sorry. I can't understand your point.
> Why does it add flush_tlb_kernel_range in case of !CONFIG_DEBUG_PAGEALLOC?

Uh, sorry, I've totally misread the function.  Never mind my comment.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
