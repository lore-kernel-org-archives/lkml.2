Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab2JWNlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:41:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638Ab2JWNlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:41:17 -0400
Message-ID: <50869E6C.1080907@redhat.com>
Date: Tue, 23 Oct 2012 09:41:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: Hugh Dickins <hughd@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH RFC] mm/swap: automatic tuning for swapin readahead
References: <50460CED.6060006@redhat.com> <20120906110836.22423.17638.stgit@zurg> <alpine.LSU.2.00.1210011418270.2940@eggly.anvils> <506AACAC.2010609@openvz.org> <alpine.LSU.2.00.1210031337320.1415@eggly.anvils> <506DB816.9090107@openvz.org> <alpine.LSU.2.00.1210081451410.1384@eggly.anvils> <20121016005049.GA1467@kernel.org> <20121022073654.GA7821@kernel.org> <alpine.LNX.2.00.1210222141170.1136@eggly.anvils> <20121023055127.GA24239@kernel.org>
In-Reply-To: <20121023055127.GA24239@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 01:51 AM, Shaohua Li wrote:

> I have no strong point against the global state method. But I'd agree making the
> heuristic simple is preferred currently. I'm happy about the patch if the '+1'
> is removed.

Without the +1, how will you figure out when to re-enable readahead?

-- 
All rights reversed
