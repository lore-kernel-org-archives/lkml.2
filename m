Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab2ERGSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 02:18:52 -0400
Received: from ngcobalt02.manitu.net ([217.11.48.102]:56656 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab2ERGSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 02:18:50 -0400
X-Greylist: delayed 1086 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2012 02:18:49 EDT
X-manitu-Original-Sender-IP: 79.230.34.1
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <4FB5E581.1090209@grandegger.com>
Date: Fri, 18 May 2012 08:00:33 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] STA2X11 CAN: CAN driver for the STA2X11 board
References: <1337288364-17572-1-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1337288364-17572-1-git-send-email-federico.vaga@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 10:59 PM, Federico Vaga wrote:
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Cc: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/net/can/Kconfig       |   11 +
>  drivers/net/can/Makefile      |    1 +
>  drivers/net/can/sta2x11_can.c | 1085 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1097 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/can/sta2x11_can.c

Thanks for your contribution. At a first glance, this driver looks
similar to the pch_can and the c_can driver. It seems that a C_CAN based
controller is used on that board as well. If that's true, it should be
handled by the C_CAN driver. To get ride of the obsolete pch_can driver,
I sent some time ago the patch "[RFC/PATCH] c_can: add driver for the
PCH CAN controller":

  http://marc.info/?t=132991563600003&r=1&w=4

I could serve as base of a generic c_can_pci driver.

Wolfgang.
