Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab2BCHLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:11:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37206 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab2BCHLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:11:07 -0500
Date: Fri, 3 Feb 2012 11:11:02 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [patch cr 3/4] c/r: procfs: add arg_start/end, env_start/end and
 exit_code members to /proc/$pid/stat
Message-ID: <20120203071102.GB1968@moon>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.377457689@openvz.org>
 <20120202152648.bff836b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202152648.bff836b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 03:26:48PM -0800, Andrew Morton wrote:
...
> > +		} else
> > +			seq_printf(m, "0 0 0 0 0 0 0 ");
> 
> heh.
> 
> We have a whizzy new num_to_str() in -mm which can later be used to
> speed this up.
> 
> This actually means that your patch will conflict horridly with
> procfs-add-num_to_str-to-speed-up-proc-stat.patch, because that patch
> redoes /proc/stat handling.  I guess I can take care of that issue.
> 

I'll check linux-next version as well.

	Cyrill
