Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab2DII6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:58:34 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:57440
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755839Ab2DII6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:58:33 -0400
X-SpamScore: -13
X-BigFish: VS-13(zzbb2dI9371I168aJ1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 9 Apr 2012 17:09:22 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Viresh Kumar <viresh.kumar@st.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/1] pinctrl: fix pinmux_check_ops error checking
Message-ID: <20120409090920.GA28029@shlinux2.ap.freescale.net>
References: <1333714689-22450-1-git-send-email-b29396@freescale.com>
 <4F7F0C7E.6030407@wwwdotorg.org>
 <4F8257F7.60302@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F8257F7.60302@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 11:31:03AM +0800, Viresh Kumar wrote:
> On 4/6/2012 9:02 PM, Stephen Warren wrote:
> > On 04/06/2012 06:18 AM, Dong Aisheng wrote:
> >> > From: Dong Aisheng <dong.aisheng@linaro.org>
> >> > 
> >> > Do not use get_functions_count before checking.
> >> > 
> >> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> > 
> > IIRC, Viresh added some other get_*_count() functions in the same patch.
> > Do we need any more fixes similar to the this for those too?
> 
> Might not be required as this patch handles the pinmux_check_ops() routine.
> At other places ops is guaranteed to have correct value.
> 
Yes, core can guarantee it after pinmux_check_ops.
But i noticed for user interfaces, we may still need add some error checking
to avoid kernel oops like pinctrl_get_* and debugfs interfaces in case
the mux or config function is not supported by driver.
I'm going to send one more patch to fix it.

Regards
Dong Aisheng

