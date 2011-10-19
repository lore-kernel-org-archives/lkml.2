Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1JSGMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 02:12:39 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:48882 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1JSGMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 02:12:37 -0400
X-IronPort-AV: E=Sophos;i="4.69,370,1315180800"; 
   d="scan'208";a="8459972"
Subject: Re: [PATCH] Fix guest memory leak and panic
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Miller <davem@davemloft.net>
CC: krkumar2@in.ibm.com, rusty@rustcorp.com.au, mst@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
In-Reply-To: <20111018.151228.2056792649526003804.davem@davemloft.net>
References: <20111018080523.16861.55402.sendpatchset@krkumar2.in.ibm.com>
	 <20111018.151228.2056792649526003804.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 19 Oct 2011 07:12:35 +0100
Message-ID: <1319004755.11016.56.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 15:12 -0400, David Miller wrote:
> I'll wait for Ian's full audit,

The result of that is in
<1318931232.16132.65.camel@zakaz.uk.xensource.com> in this thread.

Thanks,
Ian.


