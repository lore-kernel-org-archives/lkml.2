Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab1BVBNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 20:13:16 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63933 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1BVBNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 20:13:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=vKeyG4X/030bEoASALVkK2yvzlv6UuyLxi4L31PJkgLJ6pf6mpF90IIjnx+IsxoQSx
         cau7zqZ9YN4+BWS+unih01tAt7Ezkt3cqzQ4RVuKFM0mBO7iYSwGAI7JlXZUj2RqNP3k
         XHxcT3I5DGNwQJUTgC/P6Pa7APhafyu2EUYg0=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4D5AB09C.9000106@compulab.co.il>
References: <1297786849.2596.13.camel@phoenix> <4D5AB09C.9000106@compulab.co.il>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 22 Feb 2011 09:12:55 +0800
Message-ID: <AANLkTino2vLisNgKeyXppuHwDyhLMMAcOOZjA0hgmkj6@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: support 806MHz operating points for PXA31x
 processors A2 stepping
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Igor,

> Also, there is one thing that is not related to this patch, but
> if you have the hardware, you need to be concerned with,
> is that the vcc_core voltage has to be 1.4V, otherwise your
> hardware will be unstable.

I don't see any unstable issue on my device.
But it seems the vcc_core and vcc_sram fields of pxa3xx_freq_info
are not used now.

Regards,
Axel
