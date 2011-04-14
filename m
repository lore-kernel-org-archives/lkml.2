Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab1DNMYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 08:24:43 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34508 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab1DNMYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 08:24:42 -0400
MIME-Version: 1.0
X-Originating-IP: [203.101.61.10]
In-Reply-To: <1302256664-23688-1-git-send-email-pavan_savoy@ti.com>
References: <1302256664-23688-1-git-send-email-pavan_savoy@ti.com>
Date: Thu, 14 Apr 2011 17:54:40 +0530
Message-ID: <BANLkTinyQ6kdCMG=gj1vXQifUNRA1Ewokg@mail.gmail.com>
Subject: Re: [PATCH 0/3] shared transport robustness fixes
From: Pavan Savoy <pavan_savoy@sify.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 3:27 PM,  <pavan_savoy@ti.com> wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
>
> Texas Instruments' WiLink connectivity chipset's Bluetooth, FM and GPS
> wireless technologies are interfaced over single UART, which is enabled
> by the TI-ST line discipline driver.
>
> The following patches are updates and few fixes found during robustness testing
> of the driver.
> 1. The patch handles the delayed tty receive_buf function called by the TTY layer.
> 2. Removes the dependency on rfkill for build from Kconfig
> 3. Fix for the skipping the change remote baud rate command.

Greg,

Please review and queue up for merge, if its alright..

Thanks,
Pavan


> Pavan Savoy (2):
>  drivers:misc:ti-st: handle delayed tty receive
>  drivers:misc:ti-st: remove rfkill dependency
>
> Victor Goldenshtein (1):
>  drivers:misc:ti-st: fix skip remote baud logic
>
>  drivers/misc/ti-st/Kconfig   |    1 -
>  drivers/misc/ti-st/st_core.c |   23 +++++++++++++----------
>  drivers/misc/ti-st/st_kim.c  |    6 ++++--
>  include/linux/ti_wilink_st.h |    3 ++-
>  4 files changed, 19 insertions(+), 14 deletions(-)
>
>
