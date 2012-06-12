Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2FLOWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:22:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48627 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2FLOWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:22:00 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Alessandro Rubini <rubini@gnudd.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] c_can_pci: generic module for c_can on PCI
Date: Tue, 12 Jun 2012 16:25:25 +0200
Message-ID: <2105333.GQGP4hKIYU@harkonnen>
User-Agent: KMail/4.8.3 (Linux/3.4.0-1.fc17.x86_64; KDE/4.8.3; x86_64; ; )
In-Reply-To: <4FCCC077.7000303@pengutronix.de>
References: <4FC135C6.5030206@grandegger.com> <1338816766-7089-2-git-send-email-federico.vaga@gmail.com> <4FCCC077.7000303@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +out_free_clock:
> > +	if (!priv->priv)
> 
>            ^^^
> 
> looks fishy

Also c_can_platform.c use priv->priv when it needs to get clk. I can add 
a comment to specify what the statement do.

-- 
Federico Vaga
