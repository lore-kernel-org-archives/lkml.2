Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768419Ab2KOQcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:32:47 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49406 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768402Ab2KOQcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:32:45 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: Export OF interfaces.
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
In-Reply-To: <1351699053-4533-1-git-send-email-panto@antoniou-consulting.com>
References: <1351699053-4533-1-git-send-email-panto@antoniou-consulting.com>
Date: Thu, 15 Nov 2012 16:32:41 +0000
Message-Id: <20121115163241.20E813E194B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012 17:57:33 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> Export an interface that other in-kernel users can utilize.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

I'm not going to apply this before an in-kernel user exists for this. I
know it's part of the whole runtime population of the device tree stuff
and I don't think it will survive in it's current form by the time we're
done.

g.
