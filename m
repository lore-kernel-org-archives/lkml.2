Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab0GSGml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 02:42:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab0GSGmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 02:42:40 -0400
Message-ID: <4C43F3DE.8000405@suse.de>
Date: Mon, 19 Jul 2010 08:42:38 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Jiri Kosina <jkosina@suse.cz>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        =?UTF-8?B?QW5kcsOpIEdvZGRhcmQgUm9zYQ==?= <andre.goddard@gmail.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] aic7xxx: Remove OS utility wrappers
References: <1279102377-958-1-git-send-email-penberg@cs.helsinki.fi>
In-Reply-To: <1279102377-958-1-git-send-email-penberg@cs.helsinki.fi>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> This patch removes malloc(), free(), and printf() wrappers from the aic7xxx
> SCSI driver. I didn't use pr_debug for printf because of some 'clever' uses of
> printf don't compile with the pr_debug. I didn't fix the overeager uses of
> GFP_ATOMIC either because I wanted to keep this patch as simple as possible.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
> Cc: "André Goddard Rosa" <andre.goddard@gmail.com>
> Cc: <linux-scsi@vger.kernel.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Thanks for the work. Long overdue.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
