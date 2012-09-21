Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2IUKQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:16:06 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50007 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2IUKQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:16:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120919114933.GX8832@opensource.wolfsonmicro.com>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
	<20120919112614.GE8138@sortiz-mobl>
	<20120919114933.GX8832@opensource.wolfsonmicro.com>
Date: Fri, 21 Sep 2012 18:16:02 +0800
Message-ID: <CAN1soZwZB=SHjfDVz6Li_q=0GLsQPc83ckty+XjnyeySnE5zFQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] mfd: update on 88pm860x and max8925
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, lrg@ti.com, rpurdie@rpsys.net,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 7:49 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Sep 19, 2012 at 01:26:14PM +0200, Samuel Ortiz wrote:
>
>> I applied the 5 first patches.
>> For the regulator one, I'd like to get Mark's ACK as well.
>
> I'm still waiting for an update on what the depdencies in the rest of
> the series are.

Jett's PREG patch is used to append PREG regulator. My patch is used
to avoid checking
resource of PREG regulator. Without Jett's patch, my patch doesn't
make sense. So I prefer
both of these two patches could go through into same git tree.

Best Regards
Haojian
