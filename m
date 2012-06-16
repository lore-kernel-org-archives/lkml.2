Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab2FPPoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 11:44:30 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44868 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309Ab2FPPo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 11:44:29 -0400
Date: Sat, 16 Jun 2012 19:44:24 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Emelianov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3.5] c/r: prctl: less paranoid prctl_set_mm_exe_file()
Message-ID: <20120616154424.GG32029@moon>
References: <20120616085104.14682.16723.stgit@zurg>
 <20120616090646.GD32029@moon>
 <20120616091712.GA2021@moon>
 <4FDC54FF.3020305@openvz.org>
 <20120616094714.GF32029@moon>
 <4FDCA875.6040905@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDCA875.6040905@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 07:38:29PM +0400, Konstantin Khlebnikov wrote:
> >Yeah, you've changed !path_equal to path_equal. And yes, getting rid of
> >num_exe_file_vmas is good idea. Btw, Konstantin, why do we need to
> >call for path_equal? Maybe we can simply test for mm->exe_file == NULL,
> >and refuse to change anything if it's not nil value? This will simplify
> >the code.
> 
> After removing VM_EXECUTABLE and mm->num_exe_file_vmas mm->exe_file
> will never becomes NULL automatically. Patch for this not commited yet,
> but I hope it will be in 3.6.

OK, lets stick with current patch then.

	Cyrill
