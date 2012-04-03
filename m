Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2DCD5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 23:57:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57855 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2DCD5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 23:57:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2Wha0+6BwGW0APtEX2KACyR1+9fdKpJkM+iOU1m8N6d4w@mail.gmail.com>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
 <CAH9JG2Wha0+6BwGW0APtEX2KACyR1+9fdKpJkM+iOU1m8N6d4w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Apr 2012 20:57:26 -0700
X-Google-Sender-Auth: Llk7v6g1ovrt2pEF7ua0dgtoPLU
Message-ID: <CA+55aFw1ZG9R2MzgXmi0YE64t+xH95QnVuJB55sQ6xgDbnzkyQ@mail.gmail.com>
Subject: Re: Linux 3.4-rc1
To: Kyungmin Park <kmpark@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        vdumpa@nvidia.com, hdoyu@nvidia.com, konrad.wilk@oracle.com,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 7:57 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> On Sun, Apr 1, 2012 at 8:58 AM, Linus Torvalds
>>
>>  - DMA-mapping framework. The tree now has a few more acks from
>> people, and it's largely in the same situation as HSI is: I'll
>> probably pull, but I really wanted the users who are impacted to
>> actually talk to me about it.
>
> Now Marek and Nvidia persons are used it for DMA mapping based IOMMU.
>
> Are there other person who help to merge it?
> (+CC related persons).

I want the people who want it to contact me and talk about what they
do with it. So far, I haven't seen anything.

                        Linus
