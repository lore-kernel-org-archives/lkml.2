Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab2CGUiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:38:02 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37850 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923Ab2CGUh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:37:57 -0500
Date: Thu, 8 Mar 2012 00:37:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        adobriyan@gmail.com, ebiederm@xmission.com, keescook@chromium.org,
        kosaki.motohiro@jp.fujitsu.com, matthltc@us.ibm.com, tj@kernel.org,
        xemul@parallels.com
Subject: Re: + mm-exec-rename-mm-exe_file-to-mm-exe_path.patch added to -mm
 tree
Message-ID: <20120307203752.GB6191@moon>
References: <20120306231325.D4B26A0395@akpm.mtv.corp.google.com>
 <20120307162630.GG20558@moon>
 <20120307174113.GA25366@redhat.com>
 <20120307193433.GP20619@moon>
 <20120307195104.GA5071@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307195104.GA5071@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 08:51:04PM +0100, Oleg Nesterov wrote:
...
> 
> > OOPs. Sorry for false alarm, Oleg!
> 
> No, thanks for the report and analysis.
> 
> Indeed, the patch is deadly wrong. Somehow I missed that ->f_path
> is not the pointer! So set_mm_exe_path(&bprm->file->f_path) is
> is obvioulsy wrong. I didn't bother to think about "&" think call
> needs.
> 

OK. So it is not a false alarm as I thought after
trying to write a call trace, good to know ;)

Anyway, this problem is hard to repeat and I have
no idea how I managed to hit it in first place.
It was indeed "easily" until I rebooted the test
machine.

	Cyrill
