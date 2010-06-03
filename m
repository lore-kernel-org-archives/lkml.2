Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0FCRFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:05:18 -0400
Received: from usul.saidi.cx ([204.11.33.34]:60072 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752155Ab0FCRFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:05:16 -0400
Date: Thu, 3 Jun 2010 10:05:10 -0700
From: Philip Langdale <philipl@overt.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, adq_dvb@lidskialf.net,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] mmc: make sdhci work with ricoh mmc controller
Message-ID: <20100603100510.37d02c2b@fido5>
In-Reply-To: <20100603093914.3397ac42@fido5>
References: <1275516180.30272.4.camel@maxim-laptop>
	<1275527787-3783-1-git-send-email-maximlevitsky@gmail.com>
	<20100603091113.7b1d6fc0@fido5>
	<1275582709.2563.19.camel@maxim-laptop>
	<20100603093914.3397ac42@fido5>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 09:39:14 -0700
Philip Langdale <philipl@overt.org> wrote:

> > > 
> > > Have you been able to establish if 4bit and high-speed operations
> > > work correctly through the MMC controller? I note that you didn't
> > > set SDHCI_CAN_DO_HISPD.
> > Didn't test that yet, will do.
> > I hope my MMCPlus card can do high-speed.
> 
> I should get a chance today to test this as well; I'll let you know
> what I see.
> 

Ok, I was able to try it out and setting HISPD works and 4bit seems
to work too. My MMCplus cards run at the same speed with either
controller.

--phil
