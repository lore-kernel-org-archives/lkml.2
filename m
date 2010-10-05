Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0JEPUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:20:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56483 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab0JEPUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:20:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RaLQ1tDUcgyJ35r1zBzul/K/ptl9zW1K7y2wcrgn92Et+vFZ1JBJJWudWzuxaYhRpr
         PFYzeoyUO4i7dFMSY25GhTiheEmMIAQs4RjlirQc9FRAd+IQ3wfKCBnyJ6Z9PD+irYWn
         Kjq8fgFntdPr2D+Dt8OmlSm9ZJSMM3sxwlr9I=
MIME-Version: 1.0
In-Reply-To: <1285854995-6569-5-git-send-email-s.hauer@pengutronix.de>
References: <1285854995-6569-1-git-send-email-s.hauer@pengutronix.de>
	<1285854995-6569-5-git-send-email-s.hauer@pengutronix.de>
Date: Tue, 5 Oct 2010 17:20:01 +0200
Message-ID: <AANLkTim+rs8-X7UGO1w6qGFe2ACzD8qkzu-mrww0Gt8c@mail.gmail.com>
Subject: Re: [PATCH 4/4] dmaengine: Add Freescale i.MX1/21/27 DMA driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/30 Sascha Hauer <s.hauer@pengutronix.de>:

> This driver is currently implemented as a user to the old i.MX
> DMA API. This allows us to convert each user of the old API to
> the dmaengine API one by one. Once this is done the old DMA
> driver can be merged into the i.MX dmaengine driver.

Seems like a nice path forward so FWIW
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
