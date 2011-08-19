Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1HSRCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 13:02:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38118 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1HSRCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 13:02:01 -0400
Date: Fri, 19 Aug 2011 21:01:56 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?6rmA64+Z6re8?= <dg77.kim@samsung.com>
Subject: Re: [PATCH -next] power: max8997_charger.c needs module.h
Message-ID: <20110819170156.GL22761@oksana.dev.rtsoft.ru>
References: <25829605.241141312165173236.JavaMail.weblogic@epml15>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <25829605.241141312165173236.JavaMail.weblogic@epml15>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 02:19:34AM +0000, MyungJoo Ham wrote:
> Sender : Axel Lin<axel.lin@gmail.com>
> Date : 2011-08-01 08:29 (GMT+09:00)
> >
> > power/max8997_charger.c uses interfaces from linux/module.h,
> > so it should include that file.  This fixes build errors.
> >
> > Signed-off-by: Axel Lin 
> > ---
> > drivers/power/max8997_charger.c |    1 +
> > 1 files changed, 1 insertions(+), 0 deletions(-)
> 
> Whoops. Wondering how that was missed... :(
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
