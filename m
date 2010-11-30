Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0K3OLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:11:07 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60865 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0K3OLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:11:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=m35XfC7ZKP0EUTVkf5V/9oxXRzVb05pn31rO0qA0VTyAfkBIDDkjZa96tP3fai6+gd
         WK4jvcoPu2n3dX7sRYB1AimTn+4ZU/SA39WXHv4Y8r6JJvCQUaf/wRfMeQK8EakjKsbx
         6hbrkSAXSiM3nAB0ig34bUInKVWI8EsosPX2o=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH 2/3] Reclaim invalidated page ASAP
In-Reply-To: <20101130091822.GJ13268@csn.ul.ie>
References: <cover.1291043273.git.minchan.kim@gmail.com> <053e6a3308160a8992af5a47fb4163796d033b08.1291043274.git.minchan.kim@gmail.com> <20101130100933.82E9.A69D9226@jp.fujitsu.com> <20101130091822.GJ13268@csn.ul.ie>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Tue, 30 Nov 2010 09:11:01 -0500
Message-ID: <87zksqeway.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 09:18:22 +0000, Mel Gorman <mel@csn.ul.ie> wrote:
> I would agree except as said elsewhere, it's a chicken and egg problem.
> We don't have a real world test because fadvise is not useful in its
> current iteration. I'm hoping that there will be a test comparing
> 
> rsync		on vanilla kernel
> rsync		on patched kernel
> rsync+patch	on vanilla kernel
> rsync+patch	on patched kernel
> 
> Are the results of such a test likely to happen?
> 
Yes, absolutely, although I'm sorry it has taken so long. Between
thanksgiving and the impending end of the semester things have been a
bit hectic. Nevertheless, I just finished putting together a script to
record some metics from /proc/vmstat and /proc/[pid]/statm, so at this
point I'm ready to finally take some data. Any suggestions for
particular patterns to look for in the numbers or other metrics to
record are welcome. Cheers,

- Ben
