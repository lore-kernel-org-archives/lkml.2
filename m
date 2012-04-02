Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab2DBRqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:46:49 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59734 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2DBRqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:46:47 -0400
Date: Mon, 2 Apr 2012 19:46:43 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] usb: Kconfig fix display
Message-ID: <20120402194643.4a1098fc@wker>
In-Reply-To: <1333365230-15450-1-git-send-email-plagnioj@jcrosoft.com>
References: <1333365230-15450-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Apr 2012 13:13:50 +0200
Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:

> Move HAS option before menuconfig so the USB option will show in the sub menu
> and not the drivers menu.
> Introduce in commit 53c6bc24fdc8db87109a5760579cbb060fa644cf usb: Don't make
> USB_ARCH_HAS_{XHCI,OHCI,EHCI} depend on USB_SUPPORT.
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: linux-usb@vger.kernel.org
> ---
>  drivers/usb/Kconfig |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)

Already fixed by

 http://marc.info/?l=linux-kernel&m=133245014825438&w=2
