Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0CWPQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:16:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47774 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754537Ab0CWPQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:16:18 -0400
Date: Tue, 23 Mar 2010 15:20:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] serial: TTY: new ldisc for TI BT/FM/GPS chips
Message-ID: <20100323152009.262bebdc@lxorguk.ukuu.org.uk>
In-Reply-To: <1269292756-7469-2-git-send-email-pavan_savoy@ti.com>
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com>
	<1269292756-7469-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  #define N_V253		19	/* Codec control over voice modem */
> +#define N_TI_SHARED	20	/* for TI's WL7 connectivity chips */

Be more specific or some future TI shared bus protocol might cause
confusion N_TI_WL7 sounds fine.

Alan
