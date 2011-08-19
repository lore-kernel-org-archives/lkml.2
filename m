Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1HSQwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:52:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47766 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1HSQsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:48:05 -0400
Date: Fri, 19 Aug 2011 20:48:00 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: =?utf-8?B?7ZWo66qF7KO8?= <myungjoo.ham@samsung.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?6rmA64+Z6re8?= <dg77.kim@samsung.com>
Subject: Re: [PATCH] power_supply: max8998_charger: allow full timeout not
 set, leave it unchanged
Message-ID: <20110819164800.GG22761@oksana.dev.rtsoft.ru>
References: <7137817.240911312164978364.JavaMail.weblogic@epml15>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7137817.240911312164978364.JavaMail.weblogic@epml15>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 02:16:19AM +0000, 함명주 wrote:
> Sender : Axel Lin<axel.lin@gmail.com>
> Date : 2011-08-01 08:41 (GMT+09:00)
> > Add a missing break for case 0 of pdata->timeout, otherwise it will fall
> > through to the default case and return error.
> >
> > Signed-off-by: Axel Lin 
> > ---
> > drivers/power/max8998_charger.c |    1 +
> > 1 files changed, 1 insertions(+), 0 deletions(-)
> 
> Thank you for pointing that out.
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
