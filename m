Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1LAVin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:38:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53174 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab1LAVim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:38:42 -0500
Date: Fri, 2 Dec 2011 01:38:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in
 /proc/<pid>/status
Message-ID: <20111201213836.GB14515@moon>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.835932727@openvz.org>
 <20111130140009.1ccd5af0.kamezawa.hiroyu@jp.fujitsu.com>
 <20111130060537.GK1775@moon>
 <20111201095434.GR14515@moon>
 <20111201132911.e20f1fa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201132911.e20f1fa3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 01:29:11PM -0800, Andrew Morton wrote:
> 
> That's a potentially very long hold time for tasklist_lock, and
> userspace can invoke this at a high frequency.  Not good.
> 
> I think this can all be done under rcu_read_lock() with
> list_for_each_entry_rcu().
> 

Yeah, good point, thanks Andrew!

	Cyrill
