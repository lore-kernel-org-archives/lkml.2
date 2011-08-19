Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab1HSQSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:18:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57824 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab1HSQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:18:49 -0400
Date: Fri, 19 Aug 2011 20:18:43 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Clifton Barnes <cabarnes@indesign-llc.com>,
        Peter Edwards <sweetlilmre@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] power_supply: ds2780_battery/z2_battery: add __devexit_p
 at necessary places
Message-ID: <20110819161843.GA22761@oksana.dev.rtsoft.ru>
References: <1310044513.24314.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1310044513.24314.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 09:15:13PM +0800, Axel Lin wrote:
> According to the comments in include/linux/init.h:
> 
> "Pointers to __devexit functions must use __devexit_p(function_name), the
> wrapper will insert either the function_name or NULL, depending on the config
> options."
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Clifton Barnes <cabarnes@indesign-llc.com>
> Cc: Peter Edwards <sweetlilmre@gmail.com>
> ---

Applied, thanks.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
