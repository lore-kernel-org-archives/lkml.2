Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652Ab2DJXAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:00:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48429 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759488Ab2DJXAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:00:02 -0400
Date: Wed, 11 Apr 2012 02:59:57 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH mm RESEND] c/r: prctl: update prctl_set_mm_exe_file()
 after mm->num_exe_file_vmas removal
Message-ID: <20120410225957.GP24857@moon>
References: <20120407190801.10294.76053.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120407190801.10294.76053.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2012 at 11:08:02PM +0400, Konstantin Khlebnikov wrote:
> [ fix for "c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2" from mm tree ]
> 
> After removing mm->num_exe_file_vmas kernel keeps mm->exe_file until final mmput(),
> it never becomes NULL while task is alive.
> 
> We can check for other mapped files in mm instead of checking mm->num_exe_file_vmas,
> and mark mm with flag MMF_EXE_FILE_CHANGED in order to forbid second changing of mm->exe_file.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Hi Konstantin, really sorry for delay. This should do trick for us.

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
