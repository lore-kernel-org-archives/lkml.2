Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2DYIgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:36:39 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:52618 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2DYIgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:36:37 -0400
Message-ID: <20375.46953.269684.680915@ipc1.ka-ro>
Date: Wed, 25 Apr 2012 10:35:53 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: viresh kumar <viresh.linux@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        sshtylyov@mvista.com, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        mturquette@linaro.org, akpm@linux-foundation.org, jgarzik@redhat.com,
        linux-arm-kernel@lists.infradead.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 07/12] ata/sata_mv: Remove conditional compilation of
 clk code
In-Reply-To: <20120425071418.GA2116@lunn.ch>
References: <cover.1335266056.git.viresh.kumar@st.com>
	<abbcf661dc58948794839eb0fba1d5a0950ec848.1335266056.git.viresh.kumar@st.com>
	<20120424120019.GE24089@lunn.ch>
	<CAOh2x==YaPxYxigyE=n2weoKHhu4ktGRHHGdzgs2+d1_Lo-D4Q@mail.gmail.com>
	<20120424201802.GE3628@n2100.arm.linux.org.uk>
	<CAOh2x==Se4ipK_jexOE_=82=S4p41W9Ek0Om6DrUwctSz-Wcyw@mail.gmail.com>
	<20120425052802.GF13489@lunn.ch>
	<20375.40225.227084.644318@ipc1.ka-ro>
	<20120425071418.GA2116@lunn.ch>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lunn writes:
> > AFAICT the PCI archs do not have HAVE_CLK enabled. Thus they will have
> > a dummy clk API in place that provides the driver with a non-error
> > clk_get() return value.
>  
> Hi Lothar
> 
> Please could you explain this a little bit more. What exactly is a PCI
> arch?
> 
> Most of the Orion SoC have PCIe busses. Does this make them an PCI
> arch? Because they also have HAVE_CLK. There are more SoCs with PCI.
> 
If an arch has HAVE_CLK enabled it must provide valid clocks (be it
dummy clocks) for all devices it supports.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
