Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab2JQDkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 23:40:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56503 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2JQDkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 23:40:39 -0400
MIME-Version: 1.0
In-Reply-To: <1349324490-738-1-git-send-email-festevam@gmail.com>
References: <1349324490-738-1-git-send-email-festevam@gmail.com>
Date: Wed, 17 Oct 2012 00:40:39 -0300
Message-ID: <CAOMZO5BH0W7ojLVP72-TJBgD0QkPas+rbhA+hOGJoNZSsa9WQA@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] Input: da9052_tsi.c: Fix interrupt handling
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Thu, Oct 4, 2012 at 1:21 AM, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> Currently da9062_tsi does not probe and it fails as follows:
>
> da9052 1-0048: Unable to determine device interrupts
>
> Use the new da9052 irq functions and allow the driver to probe and operate
> correctly.
>
> Tested on mx53qsb board using 'evtest' tool.
>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: <linux-input@vger.kernel.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Does this look good for you?

Regards,

Fabio Estevam
