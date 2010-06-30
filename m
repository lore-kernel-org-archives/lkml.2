Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0F3ORv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:17:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33250 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab0F3ORu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b4MYG7Y/2gP+VP25h7mUkLgdI6sNid35WBLv4aI2BsiygMpUnq6je9caiLC1+xTXG0
         vHoz9WcN6/0B8FJTTA63Cf/csCF4Xm3KKSWDPDvQHNwjTiLGNly8iii4v1qTwQFYVnjZ
         eSMgJJCj4URf6w6+oZtE9S8aOJEDJUtfRK3fU=
Date: Wed, 30 Jun 2010 16:18:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alexandre Julliard <julliard@winehq.org>,
       "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Prasad <prasad@linux.vnet.ibm.com>,
       "2 . 6 . 33 . x 2 . 6 . 34 . x" <stable@kernel.org>
Subject: Re: [GIT PULL] x86 breakpoint regression fix
Message-ID: <20100630141758.GA5243@nowhere>
References: <1277906559-10624-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277906559-10624-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 04:02:39PM +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the perf/urgent branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/urgent


Please actually pull my perf/urgent-2 branch, it has the appropriate
Tested-by tag.

Thanks.

