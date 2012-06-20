Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab2FTJ6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:58:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36558 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2FTJ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:58:38 -0400
Date: Wed, 20 Jun 2012 02:58:37 -0700 (PDT)
Message-Id: <20120620.025837.721158723130014230.davem@davemloft.net>
To: federico.vaga@gmail.com
Cc: mkl@pengutronix.de, bhupesh.sharma@st.com, sfr@canb.auug.org.au,
        netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        wg@grandegger.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <5059693.iaLYtpk3E4@harkonnen>
References: <3170667.1PZa2330KE@harkonnen>
	<20120620.020611.1696375957120854262.davem@davemloft.net>
	<5059693.iaLYtpk3E4@harkonnen>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Federico Vaga <federico.vaga@gmail.com>
Date: Wed, 20 Jun 2012 11:59:26 +0200

>> Then the driver should NEVER have been submitted without the
>> required infrastructure in place first.
> 
> This particular driver don't use the clk framework at the moment. I put 
> that lines about clk to try to be generic as possibile, but I see that I 
> made a mistake: I'm sorry.

Why would you try to be generic by using an interface currently
only available on certain platforms?

That is how you make drivers non-portable, and not generic.

