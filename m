Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab2FGSRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:17:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46684 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab2FGSRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:17:34 -0400
Subject: Re: [PATCH] ARM: mx35: add WEIM register addresses
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Christian Hemp <c.hemp@phytec.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>
In-Reply-To: <20120607180738.GM30400@pengutronix.de>
References: <20120509131638.GA2057@lovely.krouter>
	 <20120607180738.GM30400@pengutronix.de>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 07 Jun 2012 20:17:29 +0200
Message-ID: <1339093049.4704.192.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 20:07 +0200, Sascha Hauer wrote:

> The same could be used on i.MX25 aswell. I think we should clean this
> up before adding more SoCs.

:) full ack. What would you suggest? A macro?


Thanks,
  -- Christoph

