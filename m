Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2BUPsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 10:48:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab2BUPsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 10:48:54 -0500
Subject: Re: [PATCH v5 21/27] irq_domain/c6x: Use library of xlate functions
From: Mark Salter <msalter@redhat.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Date: Tue, 21 Feb 2012 10:48:33 -0500
In-Reply-To: <1329383368-12122-22-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	 <1329383368-12122-22-git-send-email-grant.likely@secretlab.ca>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1329839315.17322.5.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 02:09 -0700, Grant Likely wrote:
> The c6x irq controllers don't need to define custom .xlate hooks
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/c6x/kernel/irq.c            |    1 +
>  arch/c6x/platforms/megamod-pic.c |   14 +-------------
>  2 files changed, 2 insertions(+), 13 deletions(-)

Acked-by: Mark Salter <msalter@redhat.com>


