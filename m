Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522Ab2IEVNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:13:55 -0400
Received: from tundra.namei.org ([65.99.196.166]:48399 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab2IEVNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:13:53 -0400
Date: Thu, 6 Sep 2012 07:08:46 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] security: allow Yama to be unconditionally stacked
In-Reply-To: <20120904203213.GA3617@www.outflux.net>
Message-ID: <alpine.LRH.2.02.1209060708210.23870@tundra.namei.org>
References: <20120904203213.GA3617@www.outflux.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012, Kees Cook wrote:

> Unconditionally call Yama when CONFIG_SECURITY_YAMA_STACKED is selected,
> no matter what LSM module is primary.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next



-- 
James Morris
<jmorris@namei.org>
