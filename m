Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2FPJGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 05:06:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57515 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2FPJGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 05:06:52 -0400
Date: Sat, 16 Jun 2012 13:06:46 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, linux-mm@kvack.org,
        Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3.5] c/r: prctl: less paranoid prctl_set_mm_exe_file()
Message-ID: <20120616090646.GD32029@moon>
References: <20120616085104.14682.16723.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616085104.14682.16723.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 12:51:04PM +0400, Konstantin Khlebnikov wrote:
> "no other files mapped" requirement from my previous patch
> (c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file_vmas removal)
> is too paranoid, it forbids operation even if there mapped one shared-anon vma.
> 
> Let's check that current mm->exe_file already unmapped, in this case exe_file
> symlink already outdated and its changing is reasonable.
> 
> Plus, this patch fixes exit code in case operation success.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Matt Helsley <matthltc@us.ibm.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> ---

Ack! Thanks again, Konstantin!

	Cyrill
