Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab1HSQkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:40:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62278 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1HSQkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:40:10 -0400
Date: Fri, 19 Aug 2011 20:40:04 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Cc: dwmw2@infradead.org, dilinger@queued.net, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH RESEND 1/2] olpc_battery: bind to device tree
Message-ID: <20110819164004.GE22761@oksana.dev.rtsoft.ru>
References: <20110810204536.C6FCA9D401C@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110810204536.C6FCA9D401C@zog.reactivated.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 09:45:36PM +0100, Daniel Drake wrote:
> This is cleaner, and allows suspend/resume (wakeup) handlers to be
> added in an upcoming patch.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> Acked-by: Andres Salomon <dilinger@queued.net>
> ---

Nice patch set! Both patches applied, thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
