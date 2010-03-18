Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab0CRMTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 08:19:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab0CRMTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 08:19:36 -0400
Date: Thu, 18 Mar 2010 13:17:40 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Surbhi Palande <Surbhi.Palande@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Patch inclusion in stable
Message-ID: <20100318121739.GA2390@dhcp-lab-161.englab.brq.redhat.com>
References: <1268911953.4382.23.camel@subu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268911953.4382.23.camel@subu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 01:32:33PM +0200, Surbhi Palande wrote:
> Hi All,
> 
> I had a look at the 2.6.32.10 stable patches. Had a comment on the 31st
> patch in the series:
> 
> commit 7ef79e1045213953b87f45cf5993cc9c70c873ec
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> 
>     airo: fix setting zero length WEP key
> 
> The linux-2.6 source has another patch that adds the following line:
> if (WARN_ON(keylen == 0))
> >> +     return -1;
> 
> This is added through the commit
> 6510b8917948283005a125c8337d3312a8a0561c. This commit is missing in the
> 2.6.32.10 stable patches. I think it should be a part of stable patches
> too.

keylen == 0 is just bug and should never happen. As we are printing
calltrace in such situation user is informed of a bug. Return from
function in that case is nice, but not strictly necessary.

Cheers
Stanislaw
