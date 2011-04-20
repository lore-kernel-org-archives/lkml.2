Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1DTRZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 13:25:51 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33985 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1DTRZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 13:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G/DNh7RECsJHyQD/T2F6ilfobY/Oi3qWrHjMlJEQLaLOLmqaDXc1LPMGls42IPYfUN
         qUnw+hxJr7yQI62BVYEoIjP2Ypa92/BqHXY8Na9qZbldOFnV/s/ElGRsahTH0AS4KLLx
         758M9NlFTcbDQxIZYUeNC50ANpIfJzvt0xeKo=
Date: Wed, 20 Apr 2011 21:25:44 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [PATCH] power_supply: Add driver for MAX8903 charger
Message-ID: <20110420172544.GC13169@oksana.dev.rtsoft.ru>
References: <1301361016-24392-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1301361016-24392-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 10:10:16AM +0900, MyungJoo Ham wrote:
> MAX8903 is an integrated battery charger and selector with two
> power inputs (USB and AC adapter). This driver enables the charger,
> handles interrupts, and provides power-supply-class information to
> userland.
> 
> Tested on Exynos4 NURI / S5PC210 SLP7 boards.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Applied to battery-2.6.git tree, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
