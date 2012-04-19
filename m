Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab2DSXCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:02:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932602Ab2DSXCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:02:02 -0400
Date: Fri, 20 Apr 2012 00:29:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "matthltc@us.ibm.com" <matthltc@us.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>, Pavel Emelianov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: +
	c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-
	num_exe_file_vmas-removal.patch added to -mm tree
Message-ID: <20120419222950.GA5807@redhat.com>
References: <20120419185221.E8ED6A055E@akpm.mtv.corp.google.com> <20120419192005.GA13558@redhat.com> <20120419210033.GO1893@moon> <20120419211216.GA2200@redhat.com> <20120419213204.GP1893@moon> <4F908CEB.8090606@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F908CEB.8090606@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Konstantin Khlebnikov wrote:
>
>>> My question is: unless I missed something "it can't be changed again"
>>> is not actually true. A task does PR_SET_MM_EXE_FILE, then it forks
>>> the new child. The child can do PR_SET_MM_EXE_FILE again. Is this
>>> by design?
>>
>> Hmm, not sure, Konstantin?
>
> Why not? It has new pid, why it cannot change exe_file?

OK, if you do not see a problem - I agree with this patch.

I don't really understand what PR_SET_MM_EXE_FILE buys us if
parent/child can have different /proc/pid/exe links without
exec, but

> Actually I don't care too.

same here ;)

and at least this addresses the "establishes a bound on how
frequently the symlink can change" from Matt.

Oleg.

