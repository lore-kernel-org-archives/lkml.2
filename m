Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1IUMHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:07:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36346 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1IUMHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:07:34 -0400
Date: Wed, 21 Sep 2011 20:07:24 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH 40/57] dirvers/parisc: irq: Remove IRQF_DISABLED
Message-ID: <20110921120724.GA2550@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
 <1316597339-29861-41-git-send-email-yong.zhang0@gmail.com>
 <1316599624.2966.12.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1316599624.2966.12.camel@dabdike>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 02:07:04PM +0400, James Bottomley wrote:
> Firstly, we don't need 57 patches doing this ... a single one through
> the trivial tree should be sufficient (and it can nuke the flag at the
> same time).
> 
> On Wed, 2011-09-21 at 17:28 +0800, Yong Zhang wrote:
> > Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
> 
> um, that's commit e58aa3d2d0cc01ad8d6f7f640a0670433f794922

Ah, yes, not sure how I make it wrong.

Thanks,
Yong
