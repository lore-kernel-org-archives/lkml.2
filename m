Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab0FKEc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 00:32:59 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:59761 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab0FKEc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 00:32:58 -0400
X-Greylist: delayed 1372 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jun 2010 00:32:57 EDT
Message-ID: <4C11B711.70907@st.com>
Date: Fri, 11 Jun 2010 09:39:53 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: wim@iguana.be, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, shiraz.hashim@st.com,
       armando.visconti@st.com
Subject: Re: [PATCH resend] Watchdog: Adding support for ARM Primecell SP805
 Watchdog
References: <1275465783-14052-1-git-send-email-viresh.kumar@st.com>
In-Reply-To: <1275465783-14052-1-git-send-email-viresh.kumar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/2010 1:33 PM, Viresh KUMAR wrote:
> Technical Reference Manual can be found at:
> http://infocenter.arm.com/help/topic/com.arm.doc.ddi0270b/DDI0270.pdf
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/watchdog/Kconfig     |    7 +
>  drivers/watchdog/Makefile    |    1 +
>  drivers/watchdog/sp805_wdt.c |  386 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 394 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/watchdog/sp805_wdt.c
> 

Wim,

Is this patch fine or do i need to send V2?

viresh.
