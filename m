Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab1HWWIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:08:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51734 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1HWWIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:08:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110823220056.GK3895@n2100.arm.linux.org.uk>
References: <20110823151936.GM9232@opensource.wolfsonmicro.com>
	<201108232351.55432.rjw@sisk.pl>
	<CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com>
	<20110823220056.GK3895@n2100.arm.linux.org.uk>
Date: Wed, 24 Aug 2011 00:08:23 +0200
X-Google-Sender-Auth: jUJerrqxT7edjP14r86jE0z1O5s
Message-ID: <CAOS58YNuCbaOsWBfmjSUsXsArZ5ng6c0B30yswFbRAWkho6L6Q@mail.gmail.com>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
From: Tejun Heo <tj@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:00 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> How does that solve it?  IRQs disabled from assembly, which doesn't touch
> the preempt counter.

Then test something else, be it the IRQ mask bit or some other context.

-- 
tejun
