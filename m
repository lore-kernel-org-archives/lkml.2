Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab2EFDgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 23:36:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64550 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2EFDgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 23:36:19 -0400
Message-ID: <4FA57504.2070308@landley.net>
Date: Sat, 05 May 2012 13:44:20 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] Documentation: devicetree: Fix value format description
References: <1336217886-27224-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1336217886-27224-1-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 06:38 AM, Roland Stigge wrote:
> Numeric values in dts files can be specified in decimal and hex (the latter
> prefixed 0x). The current documentation is updated with this patch to prevent
> confusion about what is meant with values without "0x" (previously hex, now
> dec).

This updates the documentation to consistently say 0x in front of hex
values, but doesn't change the device tree _parser_. What did the parser
previously do with this input?

> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Rob Landley <rob@landley.net>

Should I track this one, or is Grant taking it in the device device tree
tree?

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
