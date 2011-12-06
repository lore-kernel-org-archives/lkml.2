Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1LFWgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:36:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41543 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab1LFWgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:36:03 -0500
Date: Wed, 7 Dec 2011 02:35:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111206223558.GQ29781@moon>
References: <20111206181026.GO29781@moon>
 <20111206143313.ac2e7287.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206143313.ac2e7287.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 02:33:13PM -0800, Andrew Morton wrote:
...
> 
> It's also worth adding a warning about this into the documentation for
> this procfs file.  Documentation which this patch forgot to provide,
> btw!
> 
> 

Yes, thanks for comments Andrew, I already got the feeling that I've
missed documentation update from the start_brk /proc patch ;)

I'll address all issues, thanks!

	Cyrill
