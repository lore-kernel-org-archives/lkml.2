Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab0JSVsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:48:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247Ab0JSVsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:48:39 -0400
Date: Tue, 19 Oct 2010 14:48:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: viresh kumar <viresh.kumar@st.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>, Amit VIRDI <amit.virdi@st.com>
Subject: Re: [PATCH V2 45/69] ST SPEAr: PCIE gadget suppport
Message-Id: <20101019144803.96d59689.akpm@linux-foundation.org>
In-Reply-To: <4CBD33B8.5030105@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
	<c91308e26397dbe49f384c7d3cf168593e1fe8b0.1285933332.git.viresh.kumar@st.com>
	<4CBD33B8.5030105@st.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 11:29:20 +0530
viresh kumar <viresh.kumar@st.com> wrote:

> On 10/01/2010 05:26 PM, Viresh KUMAR wrote:
> > From: Pratyush Anand <pratyush.anand@st.com>
> > 
> > This is a configurable gadget. can be configured by sysfs interface. Any
> > IP available at PCIE bus can be programmed to be used by host
> > controller.It supoorts both INTX and MSI.
> > By default, gadget is configured for INTX and SYSRAM1 is mapped to BAR0
> > with size 0x1000
> > 
> > Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> > ---
> >  drivers/misc/Kconfig                 |   10 +
> >  drivers/misc/Makefile                |    1 +
> >  drivers/misc/spear13xx_pcie_gadget.c |  888 ++++++++++++++++++++++++++++++++++
> >  3 files changed, 899 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/misc/spear13xx_pcie_gadget.c
> 
> Andrew,
> 
> Any review comments on this patch??
> 

I looked.

I'd suggest cc'ing the PCI list and maintainer on future versions.
