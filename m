Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab2ITWqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:46:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64982 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab2ITWqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:46:51 -0400
Date: Thu, 20 Sep 2012 15:44:13 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Axel Lin <axel.lin@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lp8727_charger: use IRQF_ONESHOT
Message-ID: <20120920224413.GC29721@lizard>
References: <20120823114229.GA16789@localhost>
 <A874F61F95741C4A9BA573A70FE3998F41EF19C0@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF19C0@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 02:00:43AM +0000, Kim, Milo wrote:
[...]
> > Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> > ---
[...]
> > -				IRQF_TRIGGER_FALLING,
> > +				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> >  				"lp8727_irq",
> >  				pchg);
> >  }
> Thanks for the update.
> 
> Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Applied, thanks!
