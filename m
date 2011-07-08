Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1GHNT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 09:19:56 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:58043 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab1GHNTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 09:19:54 -0400
Date: Fri, 8 Jul 2011 17:19:50 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: gpio-charger: Fix checking return value of
 request_any_context_irq
Message-ID: <20110708131950.GC1008@oksana.dev.rtsoft.ru>
References: <1309773855.2267.1.camel@phoenix>
 <4E119250.8090009@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E119250.8090009@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 12:13:36PM +0200, Lars-Peter Clausen wrote:
> On 07/04/2011 12:04 PM, Axel Lin wrote:
> > request_any_context_irq() returns a negative value on failure.
> > On success, it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Applied.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
