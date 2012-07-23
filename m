Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2GWWLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 18:11:07 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44813 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2GWWLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 18:11:04 -0400
Message-ID: <500DCBDF.5090800@linux.vnet.ibm.com>
Date: Mon, 23 Jul 2012 17:10:39 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] zsmalloc: s/firstpage/page in new copy map funcs
References: <1342630556-28686-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1342630556-28686-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072322-5518-0000-0000-000006423EA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I know it's the first Monday after a kernel release and
things are crazy for you.  I was hoping to get this zsmalloc
stuff in before the merge window hit so I wouldn't have to
bother you :-/  But, alas, it didn't happen that way.

Minchan acked these yesterday.  When you get a chance, could
you pull these 3 patches?  I'm wanting to send out a
promotion patch for zsmalloc and zcache based on these.

Thanks Greg!

--
Seth

