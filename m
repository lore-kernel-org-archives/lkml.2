Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0FKFaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:30:52 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:58354 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311Ab0FKFav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:30:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFllEUxR9cXY/2dsb2JhbACeeHK9aw6FCgQ
Date: Fri, 11 Jun 2010 07:30:49 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       shiraz.hashim@st.com, armando.visconti@st.com
Subject: Re: [PATCH resend] Watchdog: Adding support for ARM Primecell
	SP805 Watchdog
Message-ID: <20100611053049.GM3788@infomag.iguana.be>
References: <1275465783-14052-1-git-send-email-viresh.kumar@st.com> <4C11B711.70907@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C11B711.70907@st.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

Still need to look at it. First finishing up another project.
Probably for this weekend.

Kind regards,
Wim.

> On 6/2/2010 1:33 PM, Viresh KUMAR wrote:
> > Technical Reference Manual can be found at:
> > http://infocenter.arm.com/help/topic/com.arm.doc.ddi0270b/DDI0270.pdf
> > 
> > Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> > ---
> >  drivers/watchdog/Kconfig     |    7 +
> >  drivers/watchdog/Makefile    |    1 +
> >  drivers/watchdog/sp805_wdt.c |  386 ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 394 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/watchdog/sp805_wdt.c
> > 
> 
> Wim,
> 
> Is this patch fine or do i need to send V2?
> 
> viresh.
