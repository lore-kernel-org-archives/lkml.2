Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab1EITjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:39:43 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:33859 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab1EITjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:39:41 -0400
Subject: Re: [PATCHv2 4/5] TPS65911: Add support for added GPIO lines
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
In-Reply-To: <2900D739-7BB3-4553-A485-16FA306146D0@slimlogic.co.uk>
Date: Mon, 9 May 2011 14:39:35 -0500
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
Content-Transfer-Encoding: 8BIT
Message-Id: <FDFFAA66-0F27-48BA-8167-A4B7E559B804@slimlogic.co.uk>
References: <2900D739-7BB3-4553-A485-16FA306146D0@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4, 2011, at 7:21 PM, Jorge Eduardo Candelaria wrote:

> GPIO 1 to 8 are added for TPS65911 chip version. The gpio driver
> now handles more than one gpio lines.
> 
> Subsequent versions of the chip family can add new GPIO lines with
> minimal driver changes.
> 
> Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> ---
> drivers/mfd/tps65910-gpio.c  |   26 +++++++-----
> include/linux/mfd/tps65910.h |   90 ++++++-----------------------------------
> 2 files changed, 30 insertions(+), 86 deletions(-)
> 

Grant, are you OK with the gpio changes?

If so Liam can take it via regulator again.

Thanks,
Jorge

