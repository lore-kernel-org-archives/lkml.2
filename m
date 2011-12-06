Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1LFWIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:08:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1LFWIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:08:36 -0500
Date: Tue, 6 Dec 2011 14:08:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Add start_data, end_data, start_brk members
 to /proc/$pid/stat v2
Message-Id: <20111206140833.3b43fbeb.akpm@linux-foundation.org>
In-Reply-To: <20111205182010.GV14515@moon>
References: <20111205182010.GV14515@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011 22:20:11 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> It helps to dump and restore this mm_struct members.

Sorry, I'm not going to apply a patch with a changelog like that.

It needs a full description of how this will be used and why it is
needed.  So that others can understand and evaluate the proposal, and
any possible alternatives.

Such a description would also let us see whether this is just some
"hey, maybe we'll use this sometime" thing, in which case it should not
yet be applied.

>  fs/proc/array.c |    7 +++++--

Also, every change to any procfs interface should have an associated
change to procfs documentation.  If no relevant document exists then
heck, write one.  No exceptions.

