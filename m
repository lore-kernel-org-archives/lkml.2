Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1KWRDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:03:47 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:18267 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1KWRDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:03:46 -0500
Message-ID: <4ECD276F.3050801@tilera.com>
Date: Wed, 23 Nov 2011 12:03:43 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 9/9] tile: Make tile use the new is_idle_task()
 API
References: <20111115202736.GA11030@linux.vnet.ibm.com> <1321388885-11211-9-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1321388885-11211-9-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Narrowing cc's)

On 11/15/2011 3:30 PM, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> Change from direct comparison of ->pid with zero to is_idle_task().
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  arch/tile/mm/fault.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Please cc me on changes to tile architecture files - thanks!
I picked this up while belatedly catching up on LKML.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
