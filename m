Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1G2XHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 19:07:18 -0400
Received: from vostochny.stro.at ([78.47.22.85]:52930 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab1G2XHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 19:07:16 -0400
Date: Sat, 30 Jul 2011 01:06:06 +0200
From: Maximilian Attems <max@stro.at>
To: Mike Waychison <mikew@google.com>
Cc: "Andrew G. Morgan" <agm@google.com>, Eric Northup <digitaleric@google.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Eric Paris <eparis@parisplace.org>, klibc@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] syscalls: Add capset and capget
Message-ID: <20110729230606.GC3207@stro.at>
References: <20110719203843.646.73383.stgit@mike2.sea.corp.google.com>
 <20110719203848.646.62196.stgit@mike2.sea.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719203848.646.62196.stgit@mike2.sea.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011, Mike Waychison wrote:

> Add the capset and capget system calls to klibc so that userland can
> invoke them.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
>  usr/include/sys/capability.h   |   10 ++++++++++
>  usr/klibc/SYSCALLS.def         |    6 ++++++
>  usr/klibc/syscalls/syscommon.h |    1 +
>  3 files changed, 17 insertions(+), 0 deletions(-)
>  create mode 100644 usr/include/sys/capability.h
> 

applied and pushed. thank you.

-- 
maks
