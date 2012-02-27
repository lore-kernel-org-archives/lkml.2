Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2B0WtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:49:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2B0WtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:49:02 -0500
Date: Mon, 27 Feb 2012 14:49:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: viresh kumar <viresh.linux@gmail.com>
Cc: salvatore.dedominicis@st.com, bhavna.yadav@st.com, rajeev-dlh.kumar@st.com,
        Viresh Kumar <viresh.kumar@st.com>, pratyush.anand@st.com,
        shiraz.hashim@st.com, deepak.sikri@st.com, mirko.gardi@st.com,
        vipulkumar.samar@st.com, rui.zhang@intel.com, len.brown@intel.com,
        armando.visconti@st.com, amit.virdi@st.com, vincenzo.frascino@st.com,
        vipin.kumar@st.com, linux-kernel@vger.kernel.org,
        bhupesh.sharma@st.com
Subject: Re: [PATCH] thermal: Add support for thermal sensor present on
 SPEAr13xx machines
Message-Id: <20120227144900.e7a9d972.akpm@linux-foundation.org>
In-Reply-To: <CAOh2x=kszwxhwKqwKN37Yd_KRKG5DwC_5zXXevsLpUJmJsZV0w@mail.gmail.com>
References: <032b0bad50a9ad812c9a907138bb1a6caed38c74.1330068012.git.viresh.kumar@st.com>
	<20120224120251.ad8e7332.akpm@linux-foundation.org>
	<CAOh2x=kszwxhwKqwKN37Yd_KRKG5DwC_5zXXevsLpUJmJsZV0w@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012 19:30:54 -0800
viresh kumar <viresh.linux@gmail.com> wrote:

> On Feb 25, 2012 1:32 AM, "Andrew Morton" <akpm@linux-foundation.org> wrote:
> >
> 
> > The driver can be compiled for all architectures which support
> > CONFIG_THERMAL.  This includes x86_64.  Was that intended?
> >
> 
> No.
> 
> > I don't think it's necessarily a bad thing:
> 
> Ya we thought about removing spear_* from the driver. But the hardware
> looked a bit proprietary.

I don't really understand this reply.  Does it mean that you will be
updating the Kconfig logic?

