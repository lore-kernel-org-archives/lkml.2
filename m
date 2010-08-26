Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0HZPeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:34:04 -0400
Received: from r-mail2.rd.francetelecom.com ([217.108.152.42]:21458 "EHLO
	r-mail2.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753961Ab0HZPeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:34:00 -0400
Message-ID: <4C768919.30104@Free.fr>
Date: Thu, 26 Aug 2010 17:32:41 +0200
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Lightning/1.0b2 Icedove/3.1.2
MIME-Version: 1.0
To: Phil Turmel <philip@turmel.org>
CC: linux-kernel@vger.kernel.org, Florian Mickler <florian@mickler.org>
Subject: Re: Please add generic support for root=UUID= at kernel parameter
 command line (LABEL, BYID maybe also)
References: <4C728790.7050805@Free.fr> <4C72EE8F.3040708@turmel.org>
In-Reply-To: <4C72EE8F.3040708@turmel.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Aug 2010 15:32:42.0032 (UTC) FILETIME=[EC4D2B00:01CB4533]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2010 11:56 PM, Phil Turmel wrote:
> (Adding cut CC...  sorry about the duplicate)
>
> Hi Eric,

Hi Phil

I found a solution myself using the grub embedded "search --fs-uuid". I 
do it once the linux boot partition and also on one partition of the 
external disk. If the search on the external disk report an error, I 
know root=/dev/sda1 else root=/dev/sdb1. But I really think this should 
be linux job!

I also converted my /etc/fstab to LABEL=foo /foo syntax.

Now I'm really puzzled grub2 as a "search by fs uuid" command that linux 
is unable to deliver for the root device!

I have seen read hat patch for supporting this feature ext2 as early as 
in 1999!

-- eric


