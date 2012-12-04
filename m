Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2LDITh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:19:37 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40718 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2LDITg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:19:36 -0500
MIME-Version: 1.0
In-Reply-To: <1352960870-6023-1-git-send-email-sachin.kamat@linaro.org>
References: <1352960870-6023-1-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 4 Dec 2012 10:19:36 +0200
Message-ID: <CAHp75Vc1snky7yz3wL18SJPHzcqHuTfr+N3Bm8+9gF_069==Vw@mail.gmail.com>
Subject: Re: [PATCH 1/1] DMA: PL330: Use devm_* functions
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com, patches@linaro.org,
        Jassi Brar <jassisinghbrar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 8:27 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> devm_* functions are device managed and make the code and error
> handling a bit simpler.

You may add devm_request_irq to the bunch as well.

-- 
With Best Regards,
Andy Shevchenko
