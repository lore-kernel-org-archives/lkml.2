Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab2EBSTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:19:07 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60025 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab2EBSTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:19:05 -0400
Message-ID: <4FA17A95.9050603@gmail.com>
Date: Wed, 02 May 2012 14:19:01 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ulrich Drepper <drepper@akkadia.org>
CC: akpm@linux-foundation.org, dyoung@redhat.com, fengguang.wu@intel.com,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, kosaki.motohiro@gmail.com
Subject: Re: [PATCH] Cleanup page-type.c
References: <201205021441.q42Ef1ap026902@drepperk.user.openhosting.com>
In-Reply-To: <201205021441.q42Ef1ap026902@drepperk.user.openhosting.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/2/12 10:41 AM), Ulrich Drepper wrote:
> Compiling page-type.c with a recent compiler produces many warnings,
> mostly related to signed/unsigned comparisons.  This patch cleans up
> most of them.
> 
> One remaining warning is about an unused parameter.  The<compiler.h>
> file doesn't define a __unused macro (or the like) yet.  This can be
> addressed later.
> 
> The line numbers for this patch correspond to the file changed to remove
> the duplicate definitions of the KPF_* macros which is contained in
> another patch.  It should apply cleanly albeit with warnings even without
> that patch applied first.
> 
> 
> Signed-off-by: Ulrich Drepper<drepper@gmail.com>
> 
>   page-types.c |   22 +++++++++++-----------
>   1 file changed, 11 insertions(+), 11 deletions(-)

Looks good to me.
 Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


offtopic:
Wu, I have (unrelated) one question. page-type is used from production
systems nowadays. Why don't you want to move page-type.c into tools/ dir?

