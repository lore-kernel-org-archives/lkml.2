Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab2EZIgd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 04:36:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50350 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab2EZIgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 04:36:31 -0400
MIME-Version: 1.0
In-Reply-To: <4FB5E581.1090209@grandegger.com>
References: <1337288364-17572-1-git-send-email-federico.vaga@gmail.com> <4FB5E581.1090209@grandegger.com>
From: Federico Vaga <federico.vaga@gmail.com>
Date: Sat, 26 May 2012 10:36:10 +0200
Message-ID: <CAH5GJ0rFB4xaR7o-wVR3ze_UogeDW84dehh0rx5z+300ghB4uA@mail.gmail.com>
Subject: Re: [PATCH] STA2X11 CAN: CAN driver for the STA2X11 board
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks for your contribution. At a first glance, this driver looks
> similar to the pch_can and the c_can driver. It seems that a C_CAN based
> controller is used on that board as well. If that's true, it should be
> handled by the C_CAN driver. To get ride of the obsolete pch_can driver,
> I sent some time ago the patch "[RFC/PATCH] c_can: add driver for the
> PCH CAN controller":
>
>  http://marc.info/?t=132991563600003&r=1&w=4
>
> I could serve as base of a generic c_can_pci driver.

You are right, this is a C-CAN but it isn't specified on the board manual.
I compared the board manual with the Bosch C-CAN manual, and it is the same.
I'm working on a PCI module for this board, when it is ready we can think for
a generic c_can_pci

Thank you

-- 
Federico Vaga
