Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab1D1Wy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 18:54:58 -0400
Received: from tundra.namei.org ([65.99.196.166]:49073 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab1D1Wy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 18:54:57 -0400
Date: Fri, 29 Apr 2011 08:54:26 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Will Drewry <wad@chromium.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        eparis@redhat.com, agl@chromium.org, mingo@elte.hu,
        rostedt@goodmis.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH 4/7] seccomp_filter: add process state reporting
In-Reply-To: <BANLkTinfXZ3j0vG51=cQjM0FZQ5VR5ze8A@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1104290853280.26322@tundra.namei.org>
References: <1303960136-14298-1-git-send-email-wad@chromium.org> <1303960136-14298-3-git-send-email-wad@chromium.org> <20110428122334.D197.A69D9226@jp.fujitsu.com> <BANLkTinfXZ3j0vG51=cQjM0FZQ5VR5ze8A@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011, Will Drewry wrote:

> > Can't you make individual seccomp specific file?
> 
> Definitely.  Would it make sense to have /proc/<pid>/seccomp and
> /proc/<pid>/seccomp_filter?

Do you need the separate seccomp file vs. just checking what's in 
seccomp_filter ?


-- 
James Morris
<jmorris@namei.org>
