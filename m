Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1HVP4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:56:41 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35742 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254Ab1HVP4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:56:39 -0400
Subject: Re: [PATCH 01/43] signal: Add block_sigmask() for adding sigmask
 to current->blocked
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-arch@vger.kernel.org
In-Reply-To: <20110822140158.GA29312@redhat.com>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
	 <1313772419-21951-2-git-send-email-matt@console-pimps.org>
	 <1314008362.19751.22.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110822140158.GA29312@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Aug 2011 16:56:36 +0100
Message-ID: <1314028596.19751.31.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-22 at 16:01 +0200, Oleg Nesterov wrote:
> On 08/22, Matt Fleming wrote:
> >
> > (Adding linux-arch to Cc so arch maintainers will hopefully see this)
> 
> Yes, thanks.
> 
> So far I applied only this patch to
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git ptrace
> 
> But I am going to take the whole series unless I have the nack from
> maintainers. Everything looks correct.
> 
> IOW, I am going to wait a bit to collect the ACKs from the maintainers
> in case (I hope ;) they want to review these changes.
> 
> OK?

That's fine with me!

-- 
Matt Fleming, Intel Open Source Technology Center

