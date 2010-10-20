Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0JTFWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 01:22:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754589Ab0JTFWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 01:22:33 -0400
Date: Tue, 19 Oct 2010 22:22:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Message-Id: <20101019222220.892e67e4.akpm@linux-foundation.org>
In-Reply-To: <1286381895-11329-2-git-send-email-pavan_savoy@ti.com>
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com>
	<1286381895-11329-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Oct 2010 12:18:14 -0400 pavan_savoy@ti.com wrote:

> +/**
> + * st_reg_complete -
> + * to call registration complete callbacks
> + * of all protocol stack drivers
> + */
> +void st_reg_complete(struct st_data_s *st_gdata, char err)

The driver has a lot of "kerneldoc" comments which are incomplete -
they don't document the arguments.

