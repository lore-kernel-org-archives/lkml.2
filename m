Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2AWUj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:39:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40025 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab2AWUj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:39:27 -0500
Date: Tue, 24 Jan 2012 00:39:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
Message-ID: <20120123203922.GL1907@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.181674896@openvz.org>
 <CAGXu5j+JrntZcr1sZ1sHXmOTT5jCuMp5HUQnucHqEgF+LXX5VA@mail.gmail.com>
 <20120123193301.GI1907@moon>
 <CAGXu5jJ5yO0oBLo3UJQJeGse7m-oO3MJUyOJCbsCrKXVmXOmmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ5yO0oBLo3UJQJeGse7m-oO3MJUyOJCbsCrKXVmXOmmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 12:29:52PM -0800, Kees Cook wrote:
> >
> > Yeah, it there children, they will be in say " 1 2 3 4\n" format.
> > To drop this space completely i'll have to add more code, which I
> > actually trying to escape. Can we live with it? ;)
> 
> How about just:
> 
> return seq_printf(seq, "%d ", pid);
> 
> instead?
> 

ok, will update.

	Cyrill
