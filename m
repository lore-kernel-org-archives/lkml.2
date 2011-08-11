Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab1HKRKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:10:13 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:29396 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1HKRKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:10:11 -0400
Message-ID: <4E440CF1.2060000@tilera.com>
Date: Thu, 11 Aug 2011 13:10:09 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Oleg Nesterov <oleg@redhat.com>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 29/41] tile: Use set_current_blocked()
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-30-git-send-email-matt@console-pimps.org>
In-Reply-To: <1313071035-12047-30-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/11/2011 9:57 AM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
>
> As described in e6fa16ab ("signal: sigprocmask() should do
> retarget_shared_pending()") the modification of current->blocked is
> incorrect as we need to check whether the signal we're about to block
> is pending in the shared queue.
>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/tile/kernel/compat_signal.c |    5 +----
>  arch/tile/kernel/signal.c        |   16 ++++++----------
>  2 files changed, 7 insertions(+), 14 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

