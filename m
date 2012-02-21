Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab2BUPsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 10:48:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab2BUPsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 10:48:17 -0500
Subject: Re: [PATCH v5 20/27] irq_domain/c6x: constify irq_domain structures
From: Mark Salter <msalter@redhat.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Date: Tue, 21 Feb 2012 10:47:55 -0500
In-Reply-To: <1329383368-12122-21-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	 <1329383368-12122-21-git-send-email-grant.likely@secretlab.ca>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1329839277.17322.4.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 02:09 -0700, Grant Likely wrote:
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/arm/common/gic.c            |    2 +-
>  arch/c6x/kernel/irq.c            |    2 +-
>  arch/c6x/platforms/megamod-pic.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

For c6x part:

Acked-by: Mark Salter <msalter@redhat.com>


