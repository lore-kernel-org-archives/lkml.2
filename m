Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab2LJSmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:42:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2LJSmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:42:44 -0500
Message-ID: <50C62CE7.2000306@redhat.com>
Date: Mon, 10 Dec 2012 13:41:43 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [GIT TREE] Unified NUMA balancing tree, v3
References: <1354839566-15697-1-git-send-email-mingo@kernel.org> <alpine.LFD.2.02.1212101902050.4422@ionos>
In-Reply-To: <alpine.LFD.2.02.1212101902050.4422@ionos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 01:22 PM, Thomas Gleixner wrote:

> So autonuma and numacore are basically on the same page, with a slight
> advantage for numacore in the THP enabled case. balancenuma is closer
> to mainline than to autonuma/numacore.

Indeed, when the system is fully loaded, numacore does very well.

The main issues that have been observed with numacore are when
the system is only partially loaded. Something strange seems to
be going on that causes performance regressions in that situation.

-- 
All rights reversed
