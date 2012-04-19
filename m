Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab2DSWQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:16:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41236 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab2DSWQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:16:06 -0400
Date: Fri, 20 Apr 2012 02:16:02 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "matthltc@us.ibm.com" <matthltc@us.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>, Pavel Emelianov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: +
 c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-
 num_exe_file_vmas-removal.patch added to -mm tree
Message-ID: <20120419221602.GU1893@moon>
References: <20120419185221.E8ED6A055E@akpm.mtv.corp.google.com>
 <20120419192005.GA13558@redhat.com>
 <20120419210033.GO1893@moon>
 <20120419211216.GA2200@redhat.com>
 <20120419213204.GP1893@moon>
 <4F908CEB.8090606@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F908CEB.8090606@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 02:08:43AM +0400, Konstantin Khlebnikov wrote:
> >>My question is: unless I missed something "it can't be changed again"
> >>is not actually true. A task does PR_SET_MM_EXE_FILE, then it forks
> >>the new child. The child can do PR_SET_MM_EXE_FILE again. Is this
> >>by design?
> >
> >Hmm, not sure, Konstantin?
> 
> Why not? It has new pid, why it cannot change exe_file? Actually I don't care too.
> But even if we include this bit into MMF_INIT_MASK we cannot forbid exe-file change
> in childs tasks which was forked before exe-file change in parent.

OK, I see, thanks.

	Cyrill
