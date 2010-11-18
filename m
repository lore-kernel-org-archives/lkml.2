Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab0KRN6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:58:25 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45185 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866Ab0KRN6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:58:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jtB+GHb/xlhBeK3M1qFeX6cEpXoFuu1RqPzmLpP00b/xkrlZDB10SU9Mr3q7gzMHTX
         jFB+4fb9AfiJx1A8yuxIRaYZcAiXJMbU2D+aqzYrJwCwNic4506R/r0CeqE7mTiLq/Ow
         J5WmNKYhomHTh6ZOJf7BKXfr5QhmMNCMm+7g0=
Date: Thu, 18 Nov 2010 16:58:17 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] ds2760_battery: fix calculation of time_to_empty_now
Message-ID: <20101118135817.GA19527@oksana.dev.rtsoft.ru>
References: <1289558182-28817-1-git-send-email-s.neumann@raumfeld.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1289558182-28817-1-git-send-email-s.neumann@raumfeld.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 11:36:22AM +0100, Sven Neumann wrote:
> A check against division by zero was modified in commit b0525b48.
> Since this change time_to_empty_now is always reported as zero
> while the battery is discharging and as a negative value while
> the battery is charging. This is because current is negative while
> the battery is discharging.
> 
> Fix the check introduced by commit b0525b48 so that time_to_empty_now
> is reported correctly during discharge and as zero while charging.
> 
> Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
> Acked-by: Daniel Mack <daniel@caiaq.de>

Applied (with Cc: stable@kernel.org [2.6.32..2.6.36]).

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
