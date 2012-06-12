Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab2FLOtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:49:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33171 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2FLOto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:49:44 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Alessandro Rubini <rubini@gnudd.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] c_can_pci: generic module for c_can on PCI
Date: Tue, 12 Jun 2012 16:53:10 +0200
Message-ID: <2787339.ybXZAN0ltf@harkonnen>
User-Agent: KMail/4.8.3 (Linux/3.4.0-1.fc17.x86_64; KDE/4.8.3; x86_64; ; )
In-Reply-To: <4FD75648.7060702@pengutronix.de>
References: <4FC135C6.5030206@grandegger.com> <2105333.GQGP4hKIYU@harkonnen> <4FD75648.7060702@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +out_free_clock:
> > +	if (!priv->priv)
> > +		clk_put(priv->priv);
> 
> Why do you call clk_put on priv->priv, if priv->priv is NULL?

Right!

if(priv->priv)
    clk_put(priv->priv);

-- 
Federico Vaga
