Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2AXJLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 04:11:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48404 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab2AXJLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 04:11:40 -0500
Date: Tue, 24 Jan 2012 13:11:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
Message-ID: <20120124091135.GI29735@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.181674896@openvz.org>
 <20120124110730.a3536647.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124065338.GB29735@moon>
 <20120124160709.e05c51b5.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124072122.GD29735@moon>
 <m1boptmqj0.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1boptmqj0.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 12:52:03AM -0800, Eric W. Biederman wrote:
> Cyrill Gorcunov <gorcunov@gmail.com> writes:
> 
> > On Tue, Jan 24, 2012 at 04:07:09PM +0900, KAMEZAWA Hiroyuki wrote:
> >> > 
> >> > Hmm. But userspace app will get eof, so frankly I don't see
> >> > a problem here. Or maybe I miss something?
> >> > 
> >> 
> >> Userspace need to take care of whether there may be"\n" or not even
> >> if read() returns EOF.
> >> As an interface, it's BUG to say "\n" will be there if you're lucky!"
> >> (*) I know script language can handle this but we shouldn't assume that.
> >> 
> >> How about just remove "\n" at EOF  ? I think it's unnecessary.
> >> 
> >
> > Sure thing, it's not a problem to remove it completely.
> 
> Foolish question.  Is there any reason why this is a file instead
> of being the obvious directory full of symlinks?
> 

How would these symlinks look like? "../../pid"? There were a conversation
about such things (https://lkml.org/lkml/2011/12/2/142) but I suppose we
were agree on children with pids as consensus.

	Cyrill
