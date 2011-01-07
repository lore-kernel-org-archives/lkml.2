Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab1AGOrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:47:53 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46429 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1AGOrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=R6jBinIVWeija0Mo5P0j6+7zwA+1R1gBThS37mc7WDgxp2w1171IuQptf9JxGwixLc
         ea0bhnF0ItTmhktg2smOtLtHm/b2Yrg82cZbE+/8IgsYBKnxwdKAAcZsAkeDJHPFZ5S4
         Ej1Sui8LtJUBb0kuu3TwHSu87QdqAuA200wF8=
Date: Fri, 7 Jan 2011 15:47:44 +0100 (CET)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
X-X-Sender: elektroman@localhost
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] ARM: Gemini: add RTC support for Gemini SoC
In-Reply-To: <20110107093155.GN31708@n2100.arm.linux.org.uk>
Message-ID: <alpine.LNX.2.00.1101071543230.8231@localhost>
References: <1292339307-14336-1-git-send-email-ulli.kroll@googlemail.com> <20110107093155.GN31708@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Jan 2011, Russell King - ARM Linux wrote:

> On Tue, Dec 14, 2010 at 04:08:25PM +0100, Hans Ulli Kroll wrote:
> > This patch adds the driver for the rtc chip on the Gemini SoC
> 
> I'll take patch 2, but not patch 1.  There is no requirement for patch 1
> to come via my tree - it can be handled by the RTC people.
> 
> My tree is not for random driver code being merged into mainline just
> because it's used on some ARM platform somewhere.
> 
> (I'm making this request as a result of feedback from Linus on last nights
> merge of the ARM tree.)
> 
> Thanks.
> 
ACK

I already imaged this, therefore I divided this into two parts.

Ulli

