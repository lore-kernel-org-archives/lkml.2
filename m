Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab2BHGQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 01:16:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61400 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab2BHGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 01:16:58 -0500
Date: Tue, 7 Feb 2012 22:16:51 -0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        b-cousson@ti.com, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 2/4] irq: add irq_domain support to generic-chip
Message-ID: <20120208061649.GA28996@r65073-Latitude-D630>
References: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
 <1328308512-22594-3-git-send-email-robherring2@gmail.com>
 <CACxGe6u9KjMF0vLWebL0y-J4GqbqzP4HPx6w49pPOjJ51aqooQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACxGe6u9KjMF0vLWebL0y-J4GqbqzP4HPx6w49pPOjJ51aqooQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 04:47:17PM -0700, Grant Likely wrote:
> On Fri, Feb 3, 2012 at 3:35 PM, Rob Herring <robherring2@gmail.com> wrote:
...
> > +static struct irq_domain_ops irq_gc_irq_domain_ops = {
> > +       .map = irq_gc_irq_domain_map,
> > +       .xlate = irq_domain_xlate_onetwocell,
> 
> Can we hard-enforce _xlate_twocell here?  Are there any users using
> just one cell?  Alternately, can we make the caller specify if one or
> two cells are expected?
> 
I did not notice this comment until I tried Rob's v5 branch.  The imx5
TZIC uses just one cell.

-- 
Regards,
Shawn
