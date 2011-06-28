Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab1F1PPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:15:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61293 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067Ab1F1PNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:13:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH V2 0/3] Add drivers/pwm and drivers/pwm/st_pwm.c
Date: Tue, 28 Jun 2011 17:13:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: viresh kumar <viresh.kumar@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
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
References: <cover.1306831238.git.viresh.kumar@st.com> <201106271526.12848.arnd@arndb.de> <20110628100438.GI6069@pengutronix.de>
In-Reply-To: <20110628100438.GI6069@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106281713.16099.arnd@arndb.de>
X-Provags-ID: V02:K0:UXf74s+tQVcDjxd1kM+h97xL2EB3Pyfr2NNWKZdU+np
 FnS8/ayF5zHYVzjL8tgFvGNBL1p0d1dp4d2HCPZFF4eU+fxQr+
 mRNBkddbJeQK1wmk1qyAytXGmWp40PM8w+WAzDuV7r/Qkx/Cu8
 kOQmG8EOQY96uMBuxl41W6qhiDilFvHp3BZCta+RCycPYxjBde
 AmqM5X0yDTeF+XcP7gtkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, Sascha Hauer wrote:
> > 
> > Good question. If Sascha is able to come up with the patch to introduce
> > the generic layer, I think it would be good to have it go though him.
> 
> Just posted a rebased and documented series again. Let's see what
> happens. The time seems good to finally get this into the kernel.

I'd say let's go forward with your framework. The two patches currently
because they both add Makefile/Kconfig files in drivers/pwm.

Maybe you can add Viresh's patch to your series, and wait for him
to follow up with a patch to convert it?

I've tried to blindly do the conversion myself, but got stuck with the
definition of the platform device that has multiple pwms in it.
I wonder if it would be better to change the st-pwm platform
interface to define one platform_device for each of them.

	Arnd
