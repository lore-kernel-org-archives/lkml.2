Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1HEKd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:33:29 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59537 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1HEKd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:33:28 -0400
Subject: Re: [PATCH] Remove CLOCK_TICK_RATE from tsc code
From: John Stultz <john.stultz@linaro.org>
To: dsaxena@plexity.net
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110804000938.GE23503@plexity.net>
References: <20110804000938.GE23503@plexity.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Aug 2011 03:33:17 -0700
Message-ID: <1312540397.2764.50.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 17:09 -0700, Deepak Saxena wrote:
> The tsc code uses CLOCK_TICK_RATE which on x86
> is defined to just be the same as PIT_TICK_RATE.
> This patch updates the code use the later
> as we want to depecrate and remove the global
> CLOCK_TICK_RATE symbol.
> 
> Signed-off-by: Deepak Saxena <dsaxena@linaro.org>

Acked-by: John Stultz <john.stultz@linaro.org>


