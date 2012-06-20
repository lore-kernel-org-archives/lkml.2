Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2FTJ4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:56:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42690 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab2FTJz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:55:58 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: mkl@pengutronix.de, bhupesh.sharma@st.com, sfr@canb.auug.org.au,
        netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        wg@grandegger.com
Subject: Re: linux-next: build failure after merge of the net-next tree
Date: Wed, 20 Jun 2012 11:59:26 +0200
Message-ID: <5059693.iaLYtpk3E4@harkonnen>
User-Agent: KMail/4.8.3 (Linux/3.4.2-4.fc17.x86_64; KDE/4.8.3; x86_64; ; )
In-Reply-To: <20120620.020611.1696375957120854262.davem@davemloft.net>
References: <D5ECB3C7A6F99444980976A8C6D896384FAA275CBE@EAPEX1MAIL1.st.com> <3170667.1PZa2330KE@harkonnen> <20120620.020611.1696375957120854262.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then the driver should NEVER have been submitted without the
> required infrastructure in place first.

This particular driver don't use the clk framework at the moment. I put 
that lines about clk to try to be generic as possibile, but I see that I 
made a mistake: I'm sorry. An alternative solution to HAVE_CLK 
dependency can be: remove the clk_* lines because actualy nobody use 
them. In the future, if our c_can migrate to clk and our clk framework 
is accepted in the kernel, we can re-add the clk_* lines.


-- 
Federico Vaga
