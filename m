Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2CIPm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:42:29 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47483 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2CIPm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:42:28 -0500
Date: Fri, 9 Mar 2012 19:42:24 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309154224.GE13346@moon>
References: <20120308192559.GA20782@redhat.com>
 <20120308214817.GO21812@moon>
 <20120309124811.GA610@redhat.com>
 <20120309125735.GB13346@moon>
 <20120309133555.GA23040@moon>
 <20120309134732.GA3696@redhat.com>
 <20120309141349.GC13346@moon>
 <20120309142620.GA5334@redhat.com>
 <20120309144239.GD13346@moon>
 <20120309152122.GA7802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309152122.GA7802@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 04:21:22PM +0100, Oleg Nesterov wrote:
> 
> But, when you send the patch to Andrew, please remind that he
> should remove the evidence of my ignorance from -mm first.
> 

Ah, will ping him, sure. I'll send two patches in series
one -- this patch and second

"From: Andrew Vagin <avagin@openvz.org>"
"Subject: c/r: prctl: Add ability to get clear_tid_address"

for which I've got no feedback at all :( Is there some
fundamental problem with this patch? Or everyone simply
agree on it? ;) Anyway, I hope with next series I'll get
some feedback fron anyone in CC list :)

> 
> Just one note for the record, prctl_set_mm_exe_file() does
> 
> 	if (mm->num_exe_file_vmas)
> 		return -EBUSY;
> 
> We could do
> 
> 	if (mm->exe_file)
> 		return -EBUSY;
> 
> This way "because this feature is a special to C/R" becomes
> really true. IOW, you can't do PR_SET_MM_EXE_FILE twice.
> 

Sure, i'll make it this way. Thanks a lot, Oleg!!!

> I am fine either way, just I want to ensure you really want
> the current version.
> 

	Cyrill
