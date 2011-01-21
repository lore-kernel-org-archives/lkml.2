Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1AUKoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 05:44:00 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37690 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab1AUKn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 05:43:58 -0500
Date: Fri, 21 Jan 2011 10:43:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexey Charkov <alchark@gmail.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Ryan Mallon <ryan@bluewatersys.com>, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v12] ARM: Add basic architecture support for
	VIA/WonderMedia 85xx SoC's
Message-ID: <20110121104304.GJ13235@n2100.arm.linux.org.uk>
References: <4D110269.9030805@bluewatersys.com> <20101222211815.GA31054@alchark-u3s> <4D12730B.2030909@bluewatersys.com> <20101222222501.GA32693@alchark-u3s> <4D1282DA.4020804@bluewatersys.com> <20101222233821.GA20893@alchark-u3s> <AANLkTik1tcL_ABdnq5r=MCxmLJtdP0nhOzA8irP1n0CC@mail.gmail.com> <AANLkTinb3A5CJ6r4Y0D0kMwJn8ZEyf_0mb4uW99mmUZ9@mail.gmail.com> <20110115005818.GV15996@n2100.arm.linux.org.uk> <AANLkTintT+dnpKvosuzS6aMV0dw0+2rBw2=S53-D-atp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTintT+dnpKvosuzS6aMV0dw0+2rBw2=S53-D-atp@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 04:13:48AM +0300, Alexey Charkov wrote:
> Ok, life is life. Could you then please take these to your tree for .39?

Taken.  However, Lennert has been converting ARM to use the new irq_*
irq_chip methods, which your code has missed out on.  Any chance of a
follow-up patch to switch it over?
