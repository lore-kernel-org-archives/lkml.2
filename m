Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2AXHV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 02:21:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46858 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2AXHV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 02:21:27 -0500
Date: Tue, 24 Jan 2012 11:21:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
Message-ID: <20120124072122.GD29735@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.181674896@openvz.org>
 <20120124110730.a3536647.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124065338.GB29735@moon>
 <20120124160709.e05c51b5.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124160709.e05c51b5.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 04:07:09PM +0900, KAMEZAWA Hiroyuki wrote:
> > 
> > Hmm. But userspace app will get eof, so frankly I don't see
> > a problem here. Or maybe I miss something?
> > 
> 
> Userspace need to take care of whether there may be"\n" or not even
> if read() returns EOF.
> As an interface, it's BUG to say "\n" will be there if you're lucky!"
> (*) I know script language can handle this but we shouldn't assume that.
> 
> How about just remove "\n" at EOF  ? I think it's unnecessary.
> 

Sure thing, it's not a problem to remove it completely.

	Cyrill
