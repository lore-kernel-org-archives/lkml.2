Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030866Ab2CGXPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 18:15:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64219 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030654Ab2CGXP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 18:15:28 -0500
Date: Wed, 7 Mar 2012 15:15:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, hughd@google.com,
        avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120307231522.GF30676@google.com>
References: <20120306132034.ecaf8b20.akpm@linux-foundation.org>
 <20120306213437.GG32148@redhat.com>
 <20120306135531.828ca78e.akpm@linux-foundation.org>
 <20120307145556.GA11262@redhat.com>
 <20120307170544.GA30676@google.com>
 <20120307191334.GG13430@redhat.com>
 <20120307192219.GC30676@google.com>
 <20120307194229.GH13430@redhat.com>
 <20120307225629.GE30676@google.com>
 <20120307150806.1804a8b1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307150806.1804a8b1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Wed, Mar 07, 2012 at 03:08:06PM -0800, Andrew Morton wrote:
> Just the "msleep adds to load average" issue needs thinking about.

Oh, it's now requeueing delayed work item so that's solved.

> It's rather a miserable patch :(

Agreed.  Well, I'd like to think we tried hard enough for
alternatives.

Thanks.

-- 
tejun
