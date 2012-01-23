Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2AWUCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:02:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60923 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2AWUCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:02:32 -0500
Date: Tue, 24 Jan 2012 00:02:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [patch 4/4] c/r: prctl: Extend PR_SET_MM to set up more
 mm_struct entries
Message-ID: <20120123200227.GB2810@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123155543.GG1907@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 07:55:43PM +0400, Cyrill Gorcunov wrote:
> On Mon, Jan 23, 2012 at 06:20:40PM +0400, Cyrill Gorcunov wrote:
> > After restore we would like the 'ps' command show the command
> > line and evironment exactly the same it was at checkpoint time.
> > 
> > So this additional PR_SET_MM_ allow us to do so. Note that
> > these members of mm_struct is rather used for output in
> > procfs, except auxv vector which is used by ld.so mostly.
> > 
> 
> This one is with typo fixed.
> ---

After some more testing I found there is a proble, so I'll send
updated version later. Please dont review ;)

	Cyrill
