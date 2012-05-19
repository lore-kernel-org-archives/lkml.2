Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab2ESVDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 17:03:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59075 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab2ESVDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 17:03:52 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RESEND] Documentation: devicetree: Fix value format description
To: Roland Stigge <stigge@antcom.de>, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
In-Reply-To: <1337200436-26528-1-git-send-email-stigge@antcom.de>
References: <1337200436-26528-1-git-send-email-stigge@antcom.de>
Date: Sat, 19 May 2012 15:03:50 -0600
Message-Id: <20120519210350.3E7303E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012 22:33:55 +0200, Roland Stigge <stigge@antcom.de> wrote:
> Numeric values in dts files can be specified in decimal and hex (the latter
> prefixed 0x). The current documentation is updated with this patch to prevent
> confusion about what is meant with values without "0x" (previously hex, now
> dec).
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Acked-by: Rob Landley <rob@landley.net>

Applied, thanks.

g.

