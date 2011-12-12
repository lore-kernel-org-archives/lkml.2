Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1LLHim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:38:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58694 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab1LLHil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:38:41 -0500
Date: Mon, 12 Dec 2011 11:38:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Add start_data, end_data, start_brk members to
 /proc/$pid/stat v2
Message-ID: <20111212073836.GB2199@moon>
References: <20111205182010.GV14515@moon>
 <20111206140833.3b43fbeb.akpm@linux-foundation.org>
 <20111206221515.GP29781@moon>
 <20111206225315.GA20459@moon>
 <20111207090259.e2296dd3.kamezawa.hiroyu@jp.fujitsu.com>
 <20111207063308.GC20459@moon>
 <20111207070718.GA21678@moon>
 <m1boreckmq.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1boreckmq.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 11:30:21PM -0800, Eric W. Biederman wrote:
> Cyrill Gorcunov <gorcunov@gmail.com> writes:
> 
> > On Wed, Dec 07, 2011 at 10:33:08AM +0400, Cyrill Gorcunov wrote:
> >> 
> >> No problem, I'll update (These segments are filled by binfmt handlers).
> >> 
> >
> > This one should fit.
> 
> How extensively have you tested this.  I remember a few other occasions
> where adding elements to a line in a proc file have resulted in breaking
> readers.
> 

Hmm. Tested it pretty heavy on centos 5 series. I'll dig some more.

> I expect it is much safer to add this to /proc/<pid>/status rather than
> /proc/<pid>/stat.
> 

Eric, I'm fine with any file. I thought about /.../stat only because it
already has start_code/end_code, so to have all pieces in one place this
file was choosen.

	Cyrill
