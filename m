Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1HSQoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:44:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51909 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1HSQoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:44:17 -0400
Date: Fri, 19 Aug 2011 20:44:12 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>
Subject: Re: [PATCH] power_supply: fix unterminated platform_device_id table
 for max8997_charger and max8998_charger
Message-ID: <20110819164412.GF22761@oksana.dev.rtsoft.ru>
References: <25685223.241031312165079264.JavaMail.weblogic@epml15>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <25685223.241031312165079264.JavaMail.weblogic@epml15>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 02:18:00AM +0000, MyungJoo Ham wrote:
> Sender : Axel Lin<axel.lin@gmail.com>
> Date : 2011-08-01 08:23 (GMT+09:00)
> > The platform_device_id table is supposed to be zero-terminated.
> >
> > Signed-off-by: Axel Lin 
> > ---
> > drivers/power/max8997_charger.c |    1 +
> > drivers/power/max8998_charger.c |    1 +
> > 2 files changed, 2 insertions(+), 0 deletions(-)
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
