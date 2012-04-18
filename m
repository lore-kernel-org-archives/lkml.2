Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2DRCj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:39:57 -0400
Received: from tundra.namei.org ([65.99.196.166]:58686 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab2DRCj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:39:56 -0400
Date: Wed, 18 Apr 2012 12:39:35 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Will Drewry <wad@chromium.org>
cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 2/2] seccomp: fix build warnings when there is no
 CONFIG_SECCOMP_FILTER
In-Reply-To: <1334692161-6834-2-git-send-email-wad@chromium.org>
Message-ID: <alpine.LRH.2.02.1204181239110.23644@tundra.namei.org>
References: <1334692161-6834-1-git-send-email-wad@chromium.org> <1334692161-6834-2-git-send-email-wad@chromium.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
