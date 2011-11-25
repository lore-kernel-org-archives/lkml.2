Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1KYUfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 15:35:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58823 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1KYUfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 15:35:46 -0500
Date: Sat, 26 Nov 2011 00:35:40 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, Tejun Heo <tj@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>, Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH 44/55] power_supply:irq: Remove IRQF_DISABLED
Message-ID: <20111125203540.GA21345@oksana.dev.rtsoft.ru>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
 <1316681962-8217-45-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1316681962-8217-45-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 04:59:11PM +0800, Yong Zhang wrote:
> Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
> 
> So now this flag is a NOOP and can be removed.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
