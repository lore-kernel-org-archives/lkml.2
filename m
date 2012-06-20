Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2FTJGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:06:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35922 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab2FTJGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:06:12 -0400
Date: Wed, 20 Jun 2012 02:06:11 -0700 (PDT)
Message-Id: <20120620.020611.1696375957120854262.davem@davemloft.net>
To: federico.vaga@gmail.com
Cc: mkl@pengutronix.de, bhupesh.sharma@st.com, sfr@canb.auug.org.au,
        netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        wg@grandegger.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <3170667.1PZa2330KE@harkonnen>
References: <D5ECB3C7A6F99444980976A8C6D896384FAA275CBE@EAPEX1MAIL1.st.com>
	<4FE18A5E.204@pengutronix.de>
	<3170667.1PZa2330KE@harkonnen>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Federico Vaga <federico.vaga@gmail.com>
Date: Wed, 20 Jun 2012 11:03:08 +0200

>> I think the driver is currently used/tested only on ARM only, so what
>> about adding a HAVE_CLK dependency, until Viresh Kumar's patches are
>> available in net-next. Later we can remove it.
> 
> This driver is tested only on an x86 with AMBA peripherals on PCI. We 
> are developing the clk side for this new platform. 

Then the driver should NEVER have been submitted without the
required infrastructure in place first.

If what you say is true, I'm extremely pissed off about this now.

This submission was a complete cluster fuck, and it means the person
who submitted this to me didn't test the damn build even.
