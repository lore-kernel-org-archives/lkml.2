Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0HaHmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:42:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:39945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096Ab0HaHmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:42:19 -0400
Message-ID: <4C7CB237.6090606@kernel.org>
Date: Tue, 31 Aug 2010 09:41:43 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Naohiro Aota <naota@elisp.net>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] idr: describe how nextidp works in idr_get_next().
References: <m27hj8cdsw.fsf@elisp.net> <m2pqx0az4h.fsf@elisp.net>	<4C7BD45B.3050300@kernel.org> <m2bp8jbf9q.fsf@elisp.net>
In-Reply-To: <m2bp8jbf9q.fsf@elisp.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 31 Aug 2010 07:41:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/31/2010 06:02 AM, Naohiro Aota wrote:
>>From 6c61c97b5b85a350e3f195309b70a271457208ca Mon Sep 17 00:00:00 2001
> From: Naohiro Aota <naota@elisp.net>
> Date: Fri, 27 Aug 2010 17:43:46 +0900
> Subject: [PATCH 2/2] idr: describe how nextidp works in idr_get_next().
> 
> It was unclear in original kernel-doc how nextidp worked in
> idr_get_next(). Let's describe it.
> 
> Signed-off-by: Naohiro Aota <naota@elisp.net>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
