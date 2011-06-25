Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1FYCy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 22:54:27 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60025 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704Ab1FYCyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 22:54:23 -0400
X-Sasl-enc: quciW9wfLlsGHb3k+gqRTOBKveqyXJuupw8vFH7NInvs 1308970462
Date: Fri, 24 Jun 2011 23:54:19 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] PNPACPI: Register disabled resources
Message-ID: <20110625025419.GB25126@khazad-dum.debian.net>
References: <4E04FB69.3000206@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E04FB69.3000206@gmx.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011, Witold Szczeponik wrote:
> When parsing PnP resources, it may happen that some of these
> are disabled.  The current solution is to skip these resources
> completely - with the unfortunate side effect that they are not
> registered despite the fact that they exist, after all.  The
> downside of his is that these resources cannot be manipulated
> programatically.  The kernel's APM implementation does not suffer
> from this problem.
> 
> This patch fixes a problem with (at least) some vintage IBM
> ThinkPad 600E (and most likely also on the 600, 600X, and 770X
> which have a very similar layout) where some of its PnP devices
> support options where either an IRQ or DMA is disabled.  The
> manipulation of these resources is important because the 600E
> has very special requirements.
> 
> The patch applies the idea to register disabled resources to
> all types of resources, not just to IRQs and DMAs.

Maybe you could post to the linux-thinkpad ML a follow up, mentioning this
patch and how these thinkpad users should use it plus whatever userspace to
improve the suport for their boxes?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
