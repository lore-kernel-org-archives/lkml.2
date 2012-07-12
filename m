Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab2GLAXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:23:49 -0400
Received: from tundra.namei.org ([65.99.196.166]:48668 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915Ab2GLAXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:23:37 -0400
Date: Thu, 12 Jul 2012 10:23:32 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] selinux: fix regression
In-Reply-To: <20120711095030.f2db0ed9.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.2.02.1207121022520.26675@tundra.namei.org>
References: <alpine.LRH.2.02.1207120211140.24051@tundra.namei.org> <20120711095030.f2db0ed9.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Andrew Morton wrote:

> The patch was authored by eparis, not me.  I don't even know what it does (I
> never looked).  But it lets me log into my (old) Fedora test box, which
> is a distinct improvement over mainline.

Ok, it needs his signoff, then.  Not sure why it doesn't already ?


- James
-- 
James Morris
<jmorris@namei.org>
