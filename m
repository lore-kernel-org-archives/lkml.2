Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab0LZBD3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 20:03:29 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37348 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333Ab0LZBD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 20:03:28 -0500
X-Sasl-enc: VZJTPiuVTQYxLW08dDBuEa8/26TWGXtTJpT+jovEQ/Od 1293325406
Date: Sat, 25 Dec 2010 23:03:22 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jesper Juhl <jj@chaosbits.net>
Cc: ibm-acpi-devel@lists.sourceforge.net,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI Thinkpad: We must always call va_end() after
 va_start() but do not do so in thinkpad_acpi.c::acpi_evalf()
Message-ID: <20101226010322.GB16593@khazad-dum.debian.net>
References: <alpine.LNX.2.00.1012241952200.28973@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012241952200.28973@swampdragon.chaosbits.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Dec 2010, Jesper Juhl wrote:
> In drivers/platform/x86/thinkpad_acpi.c::acpi_evalf() we don't always call 
> va_end() after va_start(). This patch corrects that.

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Although that codepath is for a driver source bug, so arguably it would
be better to just BUG().

It has never been tested (or hit in practice), I think.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
