Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab2CHTgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:36:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38350 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416Ab2CHTgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:36:43 -0500
Date: Thu, 8 Mar 2012 23:36:38 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120308193638.GI21812@moon>
References: <20120308165112.GF21812@moon>
 <20120308182623.GA17221@redhat.com>
 <20120308190303.GG21812@moon>
 <20120308190534.GA19827@redhat.com>
 <20120308192504.GH21812@moon>
 <20120308192559.GA20782@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308192559.GA20782@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 08:25:59PM +0100, Oleg Nesterov wrote:
> >
> > Sure, I can drop num_exe_file_vmas != 0 case and refuse to
> > setup new exe symlink if there some VM_EXECUTABLE remains
> > unmapped. Sounds good?
> 
> Personally I like this. This is simple and _understable_, even
> if ->num_exe_file_vmas has no meaning after PR_SET_MM_EXE.
> 
> But please-please document the new special case in the changelog.
> 

Sure, will update, thanks.

	Cyrill
