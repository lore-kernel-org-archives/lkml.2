Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab0HEGkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:40:19 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:40485 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab0HEGkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:40:16 -0400
Date: Thu, 5 Aug 2010 15:40:12 +0900
From: Simon Horman <horms@verge.net.au>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andi Kleen <andi@firstfloor.org>, Michael Neuling <mikey@neuling.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: [rfc] Merge kexec-tools into the kernel tree
Message-ID: <20100805064011.GB4630@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804070647.GB24064@verge.net.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 04:06:48PM +0900, Simon Horman wrote:
> Hi,
> 
> After all the excitement of relocating kexec-tools from
> one location on kernel.org to another last week it was
> suggested to me by Michael Neuling that the merging
> kexec-tools into the kernel tree would be a good idea.
> 
> Given that there have been a bunch of issues with kexec
> on power that this would resolve. and there is precedence
> for tools in the kernel tree, this sounds entirely reasonable to me.
> So with my kexec-tools maintainer hat on, I would like to start
> a conversation about this.

Thanks to everyone for their responses. I think we can safely conclude
that the body of opinion is that its not appropriate for kexec-tools
to be included in the kernel tree. Primarily because it isn't tied
closely to the kernel ABI. As such I withdraw this proposal.

Thanks in particular to those who offered ideas on how to resolve
some of the problems that kexec-tools faces. Lets make those ideas happen.

