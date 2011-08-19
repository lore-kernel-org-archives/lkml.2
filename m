Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab1HSQtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:49:47 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51206 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab1HSQto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:49:44 -0400
Date: Fri, 19 Aug 2011 20:49:39 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Philip Rakity <prakity@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>
Subject: Re: [PATCH] power: max17042: divide by 0 Crash because r_sns init
 too late
Message-ID: <20110819164939.GH22761@oksana.dev.rtsoft.ru>
References: <11091080.93181313475012613.JavaMail.weblogic@epml13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <11091080.93181313475012613.JavaMail.weblogic@epml13>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 06:10:13AM +0000, MyungJoo Ham wrote:
> Philip Rakity<prakity@marvell.com> Date : 2011-08-13 13:18 (GMT+09:00)
> > On MMP2 brownstone divide by 0 error since probe sets r_sns
> > after calling power_supply_register.
> > 
> > Move the code up a few lines.  r_sns comes from the platform
> > data.
> > 
> > PROP_CURRENT_AVG and PROP_CURRENT divide the result by r_sns.
> > 
> > Signed-off-by: Philip Rakity 
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied, thanks.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
