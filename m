Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab0HKSHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:07:10 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34788 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471Ab0HKSHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:07:09 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, tony@atomide.com
Subject: Re: [PATCH 2/4]  Low-level initialization for hsmmc controller on LogicPD's OMAP3 SOM and TORPEDO dev kits
Organization: Deep Root Systems, LLC
References: <1281544297-18015-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
	<1281544297-18015-2-git-send-email-Jacob.Tanenbaum@logicpd.com>
Date: Wed, 11 Aug 2010 11:07:05 -0700
In-Reply-To: <1281544297-18015-2-git-send-email-Jacob.Tanenbaum@logicpd.com>
	(Jacob Tanenbaum's message of "Wed, 11 Aug 2010 12:31:35 -0400")
Message-ID: <87lj8d2fcm.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com> writes:

>     	ARM: OMAP3LOGIC: Adding SDMMC support
>              Add low-level initialization for hsmmc controller for
>              LogicPD's OMAP 3530 LV SOM and OMAP 35x Torpedo board.

Also removes mux setup of SDRC pins which is not described here.

Kevin

