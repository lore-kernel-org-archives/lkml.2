Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab2JEW1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 18:27:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50735 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540Ab2JEW1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 18:27:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6856"; a="244233123"
Date: Fri, 5 Oct 2012 17:27:33 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for hexagon
Message-ID: <20121005222732.GA1501@codeaurora.org>
References: <17368.1349380279@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17368.1349380279@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 08:51:19PM +0100, David Howells wrote:
> Can you merge the following branch into the hexagon tree please.
> 
> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.
> 
> Note that there are some fixup patches which are at the base of the branch
> aimed at you, plus all arches get the asm-generic branch merged in too.
> 
> The following changes since commit 612a9aab56a93533e76e3ad91642db7033e03b69:
> 
>   Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2012-10-03 23:29:23 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.infradead.org/users/dhowells/linux-headers.git disintegrate-hexagon
> 
> for you to fetch changes up to 0ee1d088b96a538a1c2572078283452ef39634fc:
> 
>   UAPI: (Scripted) Disintegrate arch/hexagon/include/asm (2012-10-04 18:20:45 +0100)
> 

OK, pulled into my current tree.  I'd like to wait for the generic
stuff to make it into Linus's tree before pushing it out though.


Thanks,
Richard Kuo

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
