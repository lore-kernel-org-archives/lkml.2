Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0C3LUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 07:20:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49828 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752510Ab0C3LUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 07:20:44 -0400
Date: Tue, 30 Mar 2010 12:24:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: pavan_savoy@ti.com
Cc: marcel@holtmann.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       pavan_savoy@yahoo.co.in
Subject: Re: [PATCH] drivers:staging: sources for HCI LL PM protocol
Message-ID: <20100330122440.1e3d8bf1@lxorguk.ukuu.org.uk>
In-Reply-To: <1269559223-4043-5-git-send-email-pavan_savoy@ti.com>
References: <1269559223-4043-1-git-send-email-pavan_savoy@ti.com>
	<1269559223-4043-2-git-send-email-pavan_savoy@ti.com>
	<1269559223-4043-3-git-send-email-pavan_savoy@ti.com>
	<1269559223-4043-4-git-send-email-pavan_savoy@ti.com>
	<1269559223-4043-5-git-send-email-pavan_savoy@ti.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static struct ll_struct_s *ll;

More magic globals. I think this more than anything else demonstrates why
you need some kind of proper per device context passed around

