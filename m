Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab2EJVmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:42:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37211 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2EJVmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:42:45 -0400
Message-ID: <4FAC0D1E.3000403@landley.net>
Date: Thu, 10 May 2012 13:46:54 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        gregkh@linuxfoundation.org, borislav.petkov@amd.com, riel@redhat.com,
        luto@mit.edu, avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/7] x86/tlb: unify TLB_FLUSH_ALL definition
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-2-git-send-email-alex.shi@intel.com>
In-Reply-To: <1336626013-28413-2-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 12:00 AM, Alex Shi wrote:
> Since sizeof(long) is 4 in x86_32 mode, and it's 8 in x86_64 mode,
> sizeof(long long) is also 8 byte in x86_64 mode.
> use long mode can fit TLB_FLUSH_ALL defination here both in 32 or
> 64 bits mode.

I.E. Linux follows the LP64 standad, as do the BSDs and MacOS X:

http://www.unix.org/whitepapers/64bit.html
http://www.unix.org/version2/whatsnew/lp64_wp.html

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
