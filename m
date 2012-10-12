Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab2JLMiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:38:05 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44847 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab2JLMiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:38:01 -0400
Message-ID: <50780F26.7070007@suse.cz>
Date: Fri, 12 Oct 2012 14:37:58 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Jiri Slaby <jirislaby@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kswapd0: excessive CPU usage
References: <507688CC.9000104@suse.cz> <106695.1349963080@turing-police.cc.vt.edu> <5076E700.2030909@suse.cz> <118079.1349978211@turing-police.cc.vt.edu>            <50770905.5070904@suse.cz> <119175.1349979570@turing-police.cc.vt.edu> <5077434D.7080008@suse.cz>
In-Reply-To: <5077434D.7080008@suse.cz>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 12:08 AM, Jiri Slaby wrote:
> (It's an effective revert of "mm: vmscan: scale number of pages
> reclaimed by reclaim/compaction based on failures".)

Given kswapd had hours of runtime in ps/top output yesterday in the
morning and after the revert it's now 2 minutes in sum for the last 24h,
I would say, it's gone.

Mel, you wrote me it's unlikely the patch, but not impossible in the
end. Can you take a look, please? If you need some trace-cmd output or
anything, just let us know.

This is x86_64, 6G of RAM, no swap. FWIW EXT4, SLUB, COMPACTION all
enabled/used.

thanks,
-- 
js
suse labs
