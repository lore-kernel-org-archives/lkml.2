Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2H2Rmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:42:32 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51388 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab2H2Rma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:42:30 -0400
Message-ID: <503E546C.5050503@linux.vnet.ibm.com>
Date: Wed, 29 Aug 2012 12:42:04 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] revert changes to zcache_do_preload()
References: <1345735991-6995-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120823205648.GA2066@barrios> <5036AA38.6010400@linux.vnet.ibm.com> <20120823232845.GE5369@bbox> <5037EAC8.6080403@linux.vnet.ibm.com>
In-Reply-To: <5037EAC8.6080403@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082917-7606-0000-0000-0000032C53C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forget this whole thing, these reverts do _not_ fix the issue.

I wrote a test program to exercises cleancache and
determined that this problem has existed since the as far
back at v3.1 (basically the beginning).

No recent commit caused this.

Seth

