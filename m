Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1J0Nrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 09:47:33 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:5572 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab1J0Nrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 09:47:32 -0400
X-IronPort-AV: E=Sophos;i="4.69,413,1315180800"; 
   d="scan'208";a="8621487"
Subject: Re: [GIT PATCH] big staging merge for 3.2
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Mark Einon <mark.einon@gmail.com>, Jiri Pirko <jpirko@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 27 Oct 2011 14:47:30 +0100
In-Reply-To: <CA+55aFxRETDCVs=2pLSbc1qkhUYbfexVO9KG64EP2LKNdXGCeQ@mail.gmail.com>
References: <20111026120725.GA23142@kroah.com>
	 <CA+55aFxRETDCVs=2pLSbc1qkhUYbfexVO9KG64EP2LKNdXGCeQ@mail.gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1319723250.9436.126.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-26 at 14:59 +0100, Linus Torvalds wrote:
> 
> That driver wasn't removed, it was consolidated as one big file, and
> so the fixes to the original files needed to be resolved. I tried to
> do that correctly, but there's the skb_frag_dma_map() change and the
> removal of .ndo_set_multicast_list, and while I think I did it right,
> I really want somebody who knows that code to double check me. 

The skb_frag_dma_map aspect looks fine to me.

Ian.

