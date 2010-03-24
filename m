Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab0CXXHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 19:07:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36308 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0CXXHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 19:07:50 -0400
Date: Wed, 24 Mar 2010 23:07:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Wolfram Sang <w.sang@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: pcmcia: fix checkpatch.pl issues in
	soc_common.c
Message-ID: <20100324230729.GA21359@n2100.arm.linux.org.uk>
References: <1269471898-26301-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <1269471898-26301-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269471898-26301-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 08:04:58PM -0300, Marcelo Roberto Jimenez wrote:
> -	debug(skt, 2, "mask: %s%s%s%s%s%sflags: %s%s%s%s%s%sVcc %d Vpp %d irq %d\n",
> -			(state->csc_mask==0)?"<NONE> ":"",
> -			(state->csc_mask&SS_DETECT)?"DETECT ":"",
> -			(state->csc_mask&SS_READY)?"READY ":"",
> -			(state->csc_mask&SS_BATDEAD)?"BATDEAD ":"",
> -			(state->csc_mask&SS_BATWARN)?"BATWARN ":"",
> -			(state->csc_mask&SS_STSCHG)?"STSCHG ":"",
> -			(state->flags==0)?"<NONE> ":"",
> -			(state->flags&SS_PWR_AUTO)?"PWR_AUTO ":"",
> -			(state->flags&SS_IOCARD)?"IOCARD ":"",
> -			(state->flags&SS_RESET)?"RESET ":"",
> -			(state->flags&SS_SPKR_ENA)?"SPKR_ENA ":"",
> -			(state->flags&SS_OUTPUT_ENA)?"OUTPUT_ENA ":"",
> +	debug(skt, 2,	"mask: %s%s%s%s%s%s "
> +			"flags: %s%s%s%s%s%s Vcc %d Vpp %d irq %d\n",

NAK.  Breaking kernel messages across multiple lines makes them impossible
to grep for.  checkpatch.pl is wrong on this one.
