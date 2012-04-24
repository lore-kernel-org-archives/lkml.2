Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab2DXGL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 02:11:56 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:56133 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771Ab2DXGLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 02:11:42 -0400
Message-ID: <4F9643AD.6000906@st.com>
Date: Tue, 24 Apr 2012 11:39:49 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "jgarzik@redhat.com" <jgarzik@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 08/13] net/stmmac: Remove conditional compilation of clk
 code
References: <cover.1335008617.git.viresh.kumar@st.com> <03d5825c44251e6cbbdb3c3d8e67208f0fd4619d.1335008617.git.viresh.kumar@st.com> <4F964099.7030401@st.com>
In-Reply-To: <4F964099.7030401@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/2012 11:26 AM, Giuseppe CAVALLARO wrote:
> I like this patch also because reduces ifdef in the code :-)

thanks.

> Anyway this patch doesn't apply fine either in net-next and in net.git.
> Also I wonder if you had already tested the driver build on arch w/o
> HAVE_CLK ... just to avoid kernel build failures on other platforms.
> 
> Let me know if I can help you on that.

I already sent V2, before i saw this mail. V2 will get rebased cleanly.
Yes i have tried that.

BTW, this series must go through Andrew, instead of your tree as it
has dependency patches. Just for info.

-- 
viresh
