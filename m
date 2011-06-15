Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1FORlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:41:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48906 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1FORlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:41:10 -0400
Subject: Re: [PATCH] timerfd: really wake up processes when timer is
	cancelled on clock change
From: Max Asbock <masbock@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Max Asbock <masbock@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>,
        kay.sievers@vrfy.org, virtuoso@slind.org,
        johnstul <johnstul@linux.vnet.ibm.com>
In-Reply-To: <20110614152408.0f4069b9.akpm@linux-foundation.org>
References: <1307134425.16492.104.camel@w-amax.beaverton.ibm.com>
	 <20110614152408.0f4069b9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 15 Jun 2011 10:40:07 -0700
Message-Id: <1308159607.7499.36.camel@beton>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 15:24 -0700, Andrew Morton wrote:
> On Fri, 03 Jun 2011 13:53:45 -0700 Max Asbock <masbock@linux.vnet.ibm.com> wrote:
> 
> Do you think this fix should be backported into -stable kernels?  If so
> (or if not), why?
> 

The feature this patch fixes has been introduced in 3.0, therefore there
is no need for a packport to stable kernels.

- Max

