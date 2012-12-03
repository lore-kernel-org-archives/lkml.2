Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2LCRg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:36:59 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40148
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab2LCRg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:36:58 -0500
Subject: Re: [PATCH 1/1] DMA: PL330: Use devm_* functions
From: Vinod Koul <vkoul@infradead.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: vinod.koul@intel.com, Jassi Brar <jassisinghbrar@gmail.com>,
        linux-kernel@vger.kernel.org, patches@linaro.org
In-Reply-To: <CAK9yfHzLL9K=M6nyafiEgXmtqFGWq2vA=6nO5JMeAzo-M1HcwA@mail.gmail.com>
References: <1352960870-6023-1-git-send-email-sachin.kamat@linaro.org>
	 <CAK9yfHzLL9K=M6nyafiEgXmtqFGWq2vA=6nO5JMeAzo-M1HcwA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Dec 2012 09:17:10 -0800
Message-ID: <1354555030.7077.81.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-03 at 16:50 +0530, Sachin Kamat wrote:
> On 15 November 2012 11:57, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> > devm_* functions are device managed and make the code and error
> > handling a bit simpler.
> >
> > Cc: Jassi Brar <jassisinghbrar@gmail.com>
> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Applied, Thanks


-- 
Vinod Koul
Intel Corp.

