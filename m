Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab0H3PyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:54:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:51880 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab0H3PyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:54:14 -0400
Message-ID: <4C7BD3E1.2000806@kernel.org>
Date: Mon, 30 Aug 2010 17:53:05 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Naohiro Aota <naota@elisp.net>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] idr: fix kernel-doc warnings.
References: <m27hj8cdsw.fsf@elisp.net>
In-Reply-To: <m27hj8cdsw.fsf@elisp.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 15:53:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 05:37 PM, Naohiro Aota wrote:
> Fix the following kernel-doc warnings.
> 
> % perl scripts/kernel-doc lib/idr.c > /dev/null
> Warning(lib/idr.c:300): No description found for parameter 'starting_id'
> Warning(lib/idr.c:300): Excess function parameter 'start_id' description in 'idr_get_new_above'
> Warning(lib/idr.c:485): No description found for parameter 'idp'
> Warning(lib/idr.c:596): No description found for parameter 'nextidp'
> Warning(lib/idr.c:596): Excess function parameter 'id' description in 'idr_get_next'
> Warning(lib/idr.c:774): No description found for parameter 'starting_id'
> Warning(lib/idr.c:774): Excess function parameter 'staring_id' description in 'ida_get_new_above'
> Warning(lib/idr.c:918): No description found for parameter 'ida'
> 
> Signed-off-by: Naohiro Aota <naota@elisp.net>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
