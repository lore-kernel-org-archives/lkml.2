Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2FLLwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:52:20 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:31620
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395Ab2FLLwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:52:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I1432Izz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25hf0ah)
Date: Tue, 12 Jun 2012 19:50:34 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Devendra Naga <devendra.aaru@gmail.com>,
        Dong Aisheng <B29396@freescale.com>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-mxs: Take care of frees if the
 kzalloc fails
Message-ID: <20120612115033.GG25534@shlinux2.ap.freescale.net>
References: <1339243283-28068-1-git-send-email-devendra.aaru@gmail.com>
 <CACRpkdb+GwB_VxfmPSwfc-1BfCs+fePSqnN3binY0xttb5p7xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdb+GwB_VxfmPSwfc-1BfCs+fePSqnN3binY0xttb5p7xA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 01:31:25PM +0200, Linus Walleij wrote:
> On Sat, Jun 9, 2012 at 2:01 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:
> 
> > if there is no purecfg , the group pointer is allocated using kzalloc and if it
> > fails to allocate, we wont free the new_map,
> >
> > if config is true, we call kmemdup and if it
> > fails to do so we wont free the allocated group if there is no purecfg.
> >
> > fix this by doing the frees of new_map pointer and group pointers.
> >
> > Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> 
> Obviously correct so applied.
> 
> Dong, Shawn: any ACKs?
> 
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

