Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2AMBe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:34:57 -0500
Received: from tundra.namei.org ([65.99.196.166]:44099 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab2AMBez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:34:55 -0500
Date: Fri, 13 Jan 2012 12:31:53 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, luto@mit.edu,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using
 BPF
In-Reply-To: <20120112161806.21a09335@pyramind.ukuu.org.uk>
Message-ID: <alpine.LRH.2.00.1201131231140.19186@tundra.namei.org>
References: <1326302710-9427-1-git-send-email-wad@chromium.org> <1326302710-9427-2-git-send-email-wad@chromium.org> <20120112161806.21a09335@pyramind.ukuu.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012, Alan Cox wrote:

> In general I like this approach. It's simple, it's compact and it offers
> interesting possibilities for solving some interesting problem spaces,
> without the full weight of SELinux, SMACK etc which are still needed for
> heavyweight security.

Yes, I can see potential to vastly simplify MAC policy in some cases.


- James
-- 
James Morris
<jmorris@namei.org>
