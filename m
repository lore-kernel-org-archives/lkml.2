Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab2BAOED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:04:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56427 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab2BAOEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:04:01 -0500
Date: Wed, 1 Feb 2012 15:03:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, len.brown@intel.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] PM/Freezer: Make thaw_processes() thaw only
 userspace tasks
Message-ID: <20120201140357.GD3673@elf.ucw.cz>
References: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com>
 <20120130231437.11129.3708.stgit@srivatsabhat.in.ibm.com>
 <20120130233055.GE27616@google.com>
 <4F27311C.5020200@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F27311C.5020200@linux.vnet.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The thing is that, I wanted to avoid a bug in the patch posted at
> https://lkml.org/lkml/2012/1/29/47 as explained in the link.
> 
> So I guess I should have simply done:
> 
> freeze_kernel_threads() calls thaw_kernel_threads() upon error.

Seems like a good idea. When error is reported, call should be NOP.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
