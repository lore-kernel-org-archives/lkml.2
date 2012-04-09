Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab2DIDcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 23:32:32 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:48666 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754988Ab2DIDca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 23:32:30 -0400
Message-ID: <4F8257F7.60302@st.com>
Date: Mon, 9 Apr 2012 09:01:03 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dong Aisheng <b29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/1] pinctrl: fix pinmux_check_ops error checking
References: <1333714689-22450-1-git-send-email-b29396@freescale.com> <4F7F0C7E.6030407@wwwdotorg.org>
In-Reply-To: <4F7F0C7E.6030407@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/2012 9:02 PM, Stephen Warren wrote:
> On 04/06/2012 06:18 AM, Dong Aisheng wrote:
>> > From: Dong Aisheng <dong.aisheng@linaro.org>
>> > 
>> > Do not use get_functions_count before checking.
>> > 
>> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> IIRC, Viresh added some other get_*_count() functions in the same patch.
> Do we need any more fixes similar to the this for those too?

Might not be required as this patch handles the pinmux_check_ops() routine.
At other places ops is guaranteed to have correct value.

-- 
viresh
