Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab1E0HYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 03:24:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54702 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1E0HYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 03:24:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: viresh kumar <viresh.kumar@st.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Date: Fri, 27 May 2011 09:24:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Barry Song <21cnbao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "'Shiraz HASHIM'" <shiraz.hashim@st.com>,
        deepak sikri <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "'Rajeev KUMAR'" <rajeev-dlh.kumar@st.com>,
        "Vipin KUMAR (vipin.kumar@st.com)" <vipin.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Pratyush ANAND <pratyush.anand@st.com>, Amit VIRDI <amit.virdi@st.com>,
        Armando VISCONTI <armando.visconti@st.com>
References: <201105181047.17309.arnd@arndb.de> <201105191550.20129.arnd@arndb.de> <4DDF37DB.40606@st.com>
In-Reply-To: <4DDF37DB.40606@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105270924.00881.arnd@arndb.de>
X-Provags-ID: V02:K0:uJc8fbUXTM3AGzkKfXSrLiHkEgV+QlitmXsTeVf8ByO
 LXWPEkI6xTToYUp7FSPO3IDGEnAwScjTDViYLMOC1kiaa38ugi
 yxy3GaMlOTXCbwZDbcz8ksqXsy/Xaj+NTcksOMQbSVkJD7odPv
 f16fXXks5esbviTS4QcF4lM4NrYfF+Oua22cHdG0TMAX9NkyYl
 gKpB05aDO5mhdB4hl8RHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 May 2011, viresh kumar wrote:
> We also have few patchsets for ST's SPEAr SOC family. They were already
> reviewed, but never got pushed.
> 
> We will update all those pacthsets for point 2 & 3, and leave point 1 for now.
> Also we will update them with our latest changes for SPEAr and will circulate
> them ASAP.
> 
> Hope that's fine.

Sure, please do. Once we look at the patch sets, we can also discuss about
how and when to change them over to device tree. Since the spear13xx patches
you posted only have support for a single board, it should be fairly easy
to replace the board file with a generic device tree based one.

	Arnd
