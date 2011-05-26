Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab1EZSqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:46:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:4668 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758164Ab1EZSqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:46:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,275,1304319600"; 
   d="scan'208";a="8261793"
Date: Thu, 26 May 2011 11:45:23 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org
Subject: Re: [PATCH 5/5] Hook up sysconf syscall for all architectures
Message-ID: <20110526184523.GA13609@tassilo.jf.intel.com>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
 <1305329059-2017-6-git-send-email-andi@firstfloor.org>
 <BANLkTimKjtns7oFNMTLbnbyAkKi679ui5A@mail.gmail.com>
 <BANLkTik8XZnQ7T4X=V3VPY6Ap9R+Xcm3iQ@mail.gmail.com>
 <BANLkTi=_tJMGkZOK6Pm6KtD6P7bwgbt3qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=_tJMGkZOK6Pm6KtD6P7bwgbt3qQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ok, i lied about that.  i kept the patch local so that when your merge
> goes through, there wont be any conflicts.  you are still planning on
> pushing this for 2.6.40-rc1 right ?  if not, i'll just send out my
> sendmmsg wiring now.

I don't plan to push it for .40 currently.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
