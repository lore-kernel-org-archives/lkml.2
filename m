Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab2FRVX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 17:23:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61738 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2FRVX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 17:23:56 -0400
MIME-Version: 1.0
In-Reply-To: <4FDF83A5.6060703@pengutronix.de>
References: <1339674222-27699-1-git-send-email-federico.vaga@gmail.com> <4FDF83A5.6060703@pengutronix.de>
From: Federico Vaga <federico.vaga@gmail.com>
Date: Mon, 18 Jun 2012 23:23:35 +0200
Message-ID: <CAH5GJ0p_9x_6sSN=UQW0Wh57LKGKwXnAiO+8UoB=Ex88gNWQsg@mail.gmail.com>
Subject: Re: [PATCH] c_can_pci: generic module for C_CAN/D_CAN on PCI
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        AnilKumar Chimata <anilkumar@ti.com>,
        Alessandro Rubini <rubini@gnudd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I get this warning:
>
> socketcan/linux/drivers/net/can/c_can/c_can_pci.c: In function 'c_can_pci_probe':
> socketcan/linux/drivers/net/can/c_can/c_can_pci.c:71: warning: 'priv' may be used uninitialized in this function
>
> What about:
>
> -       pci_iounmap(pdev, priv->base);
> +       pci_iounmap(pdev, addr);

I didn't get this warning, but I read again the code and the warning
is correct, so pci_iounmap(pdev, addr) is the right way.

-- 
Federico Vaga
