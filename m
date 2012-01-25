Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2AYGz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 01:55:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37615 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2AYGz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 01:55:56 -0500
Date: Wed, 25 Jan 2012 10:55:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
Message-ID: <20120125065551.GD2005@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.181674896@openvz.org>
 <20120124110730.a3536647.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124065338.GB29735@moon>
 <20120124160709.e05c51b5.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124072122.GD29735@moon>
 <m1boptmqj0.fsf@fess.ebiederm.org>
 <20120124091135.GI29735@moon>
 <4F1F576A.9090102@gmail.com>
 <m1r4yoedkm.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r4yoedkm.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 06:11:21PM -0800, Eric W. Biederman wrote:
> KOSAKI Motohiro <kosaki.motohiro@gmail.com> writes:
> >>
> >> How would these symlinks look like? "../../pid"? There were a conversation
> >> about such things (https://lkml.org/lkml/2011/12/2/142) but I suppose we
> >> were agree on children with pids as consensus.
> >
> > I couldn't find any agreement in this link. Suppose wrong url?
> 
> Now that you have reminded me of this thread.  I can say that the
> link would need to look like ../../pid.  Our children will always
> be thread group leaders, so we can safely point to the /proc/<pid>
> directories.  So readlink would return ../../<pid> or however many
> dots are needed.  Follow link could just warp us to that directory
> as it does for the other magic proc symlinks.
> 
> My feeling is that a children subdirectory would be a lot more useful
> than a simple file that lists the children.
> 

I'll check what I can do, thanks.

	Cyrill
