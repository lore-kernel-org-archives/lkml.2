Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab2EOA2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:28:44 -0400
Received: from tundra.namei.org ([65.99.196.166]:36902 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855Ab2EOA2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:28:42 -0400
Date: Tue, 15 May 2012 10:28:37 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Yama: replace capable() with ns_capable()
In-Reply-To: <20120514171928.GA21943@www.outflux.net>
Message-ID: <alpine.LRH.2.02.1205151028080.26396@tundra.namei.org>
References: <20120514171928.GA21943@www.outflux.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Kees Cook wrote:

> When checking capabilities, the question we want to be asking is "does
> current() have the capability in the child's namespace?"
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
