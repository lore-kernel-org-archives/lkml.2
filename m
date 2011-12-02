Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1LBMp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:45:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37931 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab1LBMp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:45:57 -0500
Date: Fri, 2 Dec 2011 16:45:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Pedro Alves <pedro@codesourcery.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in
 /proc/<pid>/status
Message-ID: <20111202124551.GD14515@moon>
References: <20111129191252.769160532@openvz.org>
 <20111201095434.GR14515@moon>
 <20111202094010.ca2dee4c.kamezawa.hiroyu@jp.fujitsu.com>
 <201112021241.04471.pedro@codesourcery.com>
 <4ED8C7DE.4050107@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED8C7DE.4050107@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 04:43:10PM +0400, Pavel Emelyanov wrote:
...
> >>
> >> Yes, I like /children file. other points seems to be pointed out by other
> >> reviewers. 
> > 
> > Any reason this is a file instead of a directory like /proc/PID/task/ ?
> > 
> > $ sudo ls /proc/8167/task/
> > 8167  854  855  856  857  858  859
> > $ sudo ls /proc/8167/task/855/
> > attr    clear_refs  cpuset   exe     io       loginuid  mountinfo  oom_adj        pagemap      sched      smaps  statm    wchan
> > auxv    cmdline     cwd      fd      latency  maps      mounts     oom_score      personality  schedstat  stack  status
> > cgroup  comm        environ  fdinfo  limits   mem       numa_maps  oom_score_adj  root         sessionid  stat   syscall
> > 
> > Much easier to follow the chain from the command line this way.
> 
> What do you propose to put into these directories? Another directories named with
> children pid-s?
> 

Yes, I suppose additional directory/links and whatever would be just
noneeded overhead.

	Cyrill
