Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1CAOMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:12:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab1CAOMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:12:36 -0500
Date: Tue, 1 Mar 2011 15:12:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>, Eric Paris <eparis@redhat.com>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/00]Remove one to many n's in a word.
In-Reply-To: <1298781250-2718-17-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1103011507120.32580@pobox.suse.cz>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com> <1298781250-2718-17-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Feb 2011, Justin P. Mattock wrote:

> The Patch below removes one to many "n's" in a word.. 

Hi Justin,

I have applied all the patches from the series which were not present in 
linux-next as of today (in a squashed-together form, no need to have 
separated commits for such cosmetic changes).

I'd suggest that, unless any subsystem maintainer explicitly states 
otherwise, you submit all such similar changes justo to trivial@kernel.org 
(and perhaps CC LKML). I propose this because:

- I believe most maintainers don't care about these changes and don't need 
  to be bothered
- it reduces annoying mail traffic (tens of mails because such 
  nano-change)
- it reduces the trivial tree maintainership load, as I don't have to wait 
  and cross-check which maintainer has applied which bits and which ones 
  were not picked up

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
