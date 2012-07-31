Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2GaQCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:02:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47860 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2GaQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:02:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHxy4DGCwZjDCdc3A-a3oKoMGQruDMhfq0uR+2+7nfFHoA@mail.gmail.com>
References: <1343742860-16213-1-git-send-email-damien.cassou@lifl.fr>
 <1343742860-16213-3-git-send-email-damien.cassou@lifl.fr> <CAK9yfHxy4DGCwZjDCdc3A-a3oKoMGQruDMhfq0uR+2+7nfFHoA@mail.gmail.com>
From: Damien Cassou <damien.cassou@gmail.com>
Date: Tue, 31 Jul 2012 18:01:49 +0200
Message-ID: <CA+y5ggjqq+u-kkQLApEAWs9vf29LuEXq_kA51T6HxsJcMM=HCQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] drivers/video/da8xx-fb.c: use devm_ functions
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole patch is incorrect because of:

On Tue, Jul 31, 2012 at 5:47 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>> -       ret = request_irq(par->irq, lcdc_irq_handler, 0,
>> -                       DRIVER_NAME, par);
>> +       ret = devm_request_irq(&device->dev, par->irq, lcdc_irq_handler, 0,
>> +                              DRIVER_NAME, par);

The following message explains why this is problematic:
http://marc.info/?l=kernel-janitors&m=134374464625591&w=2

Please ignore this whole patch altogether.

Sorry about that.

-- 
Damien Cassou
http://damiencassou.seasidehosting.st

"Lambdas are relegated to relative obscurity until Java makes them
popular by not having them." James Iry
