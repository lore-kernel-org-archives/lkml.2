Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2HaBXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 21:23:37 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38968 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2HaBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 21:23:36 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbbMiCZKf_FAph=g-BL9-AXGhkdxC=2mv01xANt8KiNoQ@mail.gmail.com>
References: <1346153444.11862.1.camel@phoenix>
	<CACRpkdbbMiCZKf_FAph=g-BL9-AXGhkdxC=2mv01xANt8KiNoQ@mail.gmail.com>
Date: Fri, 31 Aug 2012 10:23:35 +0900
Message-ID: <CANqRtoSrwdbphM+U8aymJY1A9bM+jyOr-rCRzk8tDNb6uvnNyA@mail.gmail.com>
Subject: Re: [PATCH] gpio: em: Fix checking return value of irq_alloc_descs
From: Magnus Damm <magnus.damm@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@gmail.com>, Magnus Damm <damm@opensource.se>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 9:05 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Aug 28, 2012 at 4:30 AM, Axel Lin <axel.lin@gmail.com> wrote:
>
>> irq_alloc_descs() returns negative error code on failure.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Magnuis can I have your ACK on this?

Yes, of course! I never disagree with bug fixes =)

Acked-by: Magnus Damm <damm@opensource.se>

Thanks a lot to both Axel and you!

/ magnus
