Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab1DWSrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 14:47:37 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51443 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051Ab1DWSrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 14:47:36 -0400
Date: Sat, 23 Apr 2011 19:47:34 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/7] signal: cleanup sys_rt_sigprocmask()
Message-ID: <20110423194734.12c0e27d@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110423182031.GB1472@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<20110418134700.GI15951@redhat.com>
	<20110422153027.12d16b7e@mfleming-mobl1.ger.corp.intel.com>
	<20110423182031.GB1472@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011 20:20:31 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> I think we should just remove this comment. It is confusing. This check
> is trivial and does not need any explanation. The comment (and the code)
> is very old, it predates the git history. I do not think this API will be
> changed, unlikely we need to handle the different sized sigset_t's.
> 
> What do you think?

Sure, that is OK with me!

-- 
Matt Fleming, Intel Open Source Technology Center
