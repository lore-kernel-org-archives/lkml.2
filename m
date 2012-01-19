Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab2ASRe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:34:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38882 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2ASRe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:34:57 -0500
MIME-Version: 1.0
In-Reply-To: <4F153A3E.8010409@st.com>
References: <cover.1326707233.git.viresh.kumar@st.com>
	<5e5d0fcff79b9b78e64c7424317d6b77736eca43.1326707233.git.viresh.kumar@st.com>
	<20120116105448.GT1068@n2100.arm.linux.org.uk>
	<4F140DB7.3060300@st.com>
	<CACRpkdY-4wWeD=3mJiChi6+4=iBMcd3kVh3h4JmDZ5ySXY3KCA@mail.gmail.com>
	<4F153A3E.8010409@st.com>
Date: Thu, 19 Jan 2012 18:34:56 +0100
Message-ID: <CACRpkdZWtBq_g7uem8Rsa7nsnGgyDHjd5oy5M_yJeBRnVB41yA@mail.gmail.com>
Subject: Re: [PATCH 7/8] dmaengine/dw_dmac: Unmap all memory buffers after
 completion of slave transfers
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Bhavna YADAV <bhavna.yadav@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 10:07 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

>> Why do you want to do this?
>
> This is because people can pass in flags which are
> DMA_COMPL_SKIP_SRC_UNMAP, etc.
>
> If they are not passed, then DMA driver must do it for them.

OK I see why it's confusing.

That flag is only for memcpy jobs.

Only memcpy jobs maps/unmaps buffers.

Slave transfers are mapped/unmapped by the driver.

Yours,
Linus Walleij
