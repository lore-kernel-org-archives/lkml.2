Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab0GWLfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:35:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:49264 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab0GWLfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:35:16 -0400
Message-ID: <4C497E5F.80301@kernel.org>
Date: Fri, 23 Jul 2010 13:34:55 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>,
        linux-cifs@vger.kernel.org
Subject: Re: linux-next: manual merge of the workqueues tree with the Linus'
 tree
References: <20100723144600.dd4da992.sfr@canb.auug.org.au>	<4C497CD5.5010908@kernel.org> <20100723213148.3d2193a3.sfr@canb.auug.org.au>
In-Reply-To: <20100723213148.3d2193a3.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Jul 2010 11:34:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/23/2010 01:31 PM, Stephen Rothwell wrote:
>> Yes, one failure case is removed, so that would be correct.
> 
> Thanks for the confirmation.  This should probably be fixed in the
> workqueues tree before it is merged upstream.

I was thinking about sending pull request w/ a note describing how to
resolve the conflict.  Would pulling in master before requesting pull
be better?

Thanks.

-- 
tejun
