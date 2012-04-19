Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab2DSWc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:32:58 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59810 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756521Ab2DSWc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:32:56 -0400
Date: Fri, 20 Apr 2012 02:32:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "matthltc@us.ibm.com" <matthltc@us.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>, Pavel Emelianov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: +
 c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-
 num_exe_file_vmas-removal.patch added to -mm tree
Message-ID: <20120419223252.GV1893@moon>
References: <20120419185221.E8ED6A055E@akpm.mtv.corp.google.com>
 <20120419192005.GA13558@redhat.com>
 <20120419210033.GO1893@moon>
 <20120419211216.GA2200@redhat.com>
 <4F9087D0.60709@openvz.org>
 <20120419215109.GA4896@redhat.com>
 <20120419220201.GR1893@moon>
 <20120419220918.GA5474@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419220918.GA5474@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 12:09:19AM +0200, Oleg Nesterov wrote:
> >
> > I guess maybe it's time to drop one-shot requirement and as result
> > we can drop MMF_EXE_FILE_CHANGED bit completely,
> 
> Plus perhaps we can remove this for_each_vma check?
>
> > making overall code simplier?
> 
> Personally I'd certainly prefer this ;)
> 
> But let me repeat to avoid the confusion. I am fine either way,
> I am not going to discuss this again unless I see something which
> looks technically wrong. And the current MMF_EXE_FILE_CHANGED
> doesn't look right even if the problem is minor.

So if there no stong agrues against, lets rip all together --
and for_each_vma and MMF_EXE_FILE_CHANGED bits, finally making
code simplier.

	Cyrill
