Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0JGVro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:47:44 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39066 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab0JGVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:47:43 -0400
Date: Thu, 7 Oct 2010 15:47:59 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: pavan_savoy@ti.com
Cc: linux-bluetooth@vger.kernel.org, marcel@holtmann.org, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers:bluetooth: Kconfig & Makefile for TI BT
Message-ID: <20101007184759.GD4893@vigoh>
References: <1286477237-7526-1-git-send-email-pavan_savoy@ti.com>
 <1286477237-7526-2-git-send-email-pavan_savoy@ti.com>
 <1286477237-7526-3-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286477237-7526-3-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* pavan_savoy@ti.com <pavan_savoy@ti.com> [2010-10-07 14:47:17 -0400]:

> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Kconfig and Makefile modifications to enable the Bluetooth
> driver for Texas Instrument's WiLink 7 chipset.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  drivers/bluetooth/Kconfig  |   10 ++++++++++
>  drivers/bluetooth/Makefile |    1 +
>  2 files changed, 11 insertions(+), 0 deletions(-)

Just merge this patch in the firt one. No need to keep this separated.

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
