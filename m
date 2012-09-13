Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab2IMQAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:00:35 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:9942 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402Ab2IMQAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:00:34 -0400
X-IronPort-AV: E=Sophos;i="4.80,417,1344211200"; 
   d="scan'208";a="14526314"
From: Ian Jackson <Ian.Jackson@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20562.800.744932.439629@mariner.uk.xensource.com>
Date: Thu, 13 Sep 2012 17:00:32 +0100
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com
Subject: Re: [Xen-devel] [PATCH 09/10] xen/swiotlb: Fix compile warnings when
	using plain integer instead of NULL pointer.
Newsgroups: chiark.mail.xen.devel
In-Reply-To: <20562.532.48940.555794@mariner.uk.xensource.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
	<m2n.s.1TBAAE-152299@chiark.greenend.org.uk>
	<20562.397.264907.380798@mariner.uk.xensource.com>
	<20562.532.48940.555794@mariner.uk.xensource.com>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Jackson writes ("Re: [Xen-devel] [PATCH 09/10] xen/swiotlb: Fix compile warnings when using plain integer instead of NULL pointer."):
> Oh wait this is Linux kernel code, not in Xen?  Still,
> Documentation/CodingStyle doesn't say that NULL is required.

Someone on irc found me this rant from Linus:
  https://lkml.org/lkml/2004/7/8/7
That suggests that perhaps someone should patch CodingStyle to
document this style requirement.

That someone shouldn't be me because I don't agree with the
requirement and a rationale I'd write for it would come out sounding
sarcastic.

Ian.
