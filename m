Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab1F0N1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:27:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52819 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759961Ab1F0N0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:26:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: viresh kumar <viresh.kumar@st.com>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH V2 0/3] Add drivers/pwm and drivers/pwm/st_pwm.c
Date: Mon, 27 Jun 2011 15:26:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1306831238.git.viresh.kumar@st.com> <4E086590.8080100@st.com>
In-Reply-To: <4E086590.8080100@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106271526.12848.arnd@arndb.de>
X-Provags-ID: V02:K0:heGAwoCuc1k2+L8E2l6kNzTYwZe8MhRagFyF6HJH1Tg
 RQcYiXP0aATyz7xbFDpGEUR06KzVNndKdz5Xae0pMeTZDdb3CO
 dQa9KoENsTOBGXdDAZ9sEudQ2uGyuWXveLKLb0w/tSCcz2s+mD
 DXoVM2FBrPtgbYTUOSTRzVP33eY+OVgItYvOWikmhQkkZE8Ay+
 TjVYoZhlo19gnJcOaGuSg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 June 2011, viresh kumar wrote:
> On 05/31/2011 02:21 PM, Viresh KUMAR wrote:
> > This patchset adds drivers/pwm directory as suggested by Arnd Bergmann in
> > following discussion:
> > 
> > http://comments.gmane.org/gmane.linux.ports.arm.kernel/118651
> > 
> > and also adds support for ST Microelectronics Pulse Width Modulator. This is
> > currently used by ST's SPEAr platform and tested on the same.
> > 
> > Changes since V1:
> >  - Moved driver to drivers/pwm/ directory from drivers/misc
> >  - arch/arm/configs/spear3xx_defconfig updated accordingly.
> > 
> > Changes since earlier patchset:
> >  - Moved driver to drivers/misc/ directory.
> > 
> > It was earlier reviewed as part of following patchset:
> > "[PATCH V6 00/17] Adding devices support for all spear machines"
> > 
> > Viresh Kumar (3):
> >   drivers/pwm st_pwm: Add support for ST's Pulse Width Modulator
> >   SPEAr3xx: Add machine support for ST's PWM IP
> >   SPEAr3xx: Update defconfig for ST's PWM
>
> Will you push this patchset through your tree or somebody else will do?

Good question. If Sascha is able to come up with the patch to introduce
the generic layer, I think it would be good to have it go though him.

Otherwise I guess I can carry it, but I'd start a new tree for
drivers/{misc,char} then and put it in there, along with patches to
move the other pwm drivers.

	Arnd
