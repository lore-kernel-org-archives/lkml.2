Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab2IDRcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 13:32:08 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:42380 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752112Ab2IDRcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 13:32:06 -0400
Message-ID: <50463A93.1080108@xenotime.net>
Date: Tue, 04 Sep 2012 10:29:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: linux-next: Tree for Sept 4 (cma)
References: <20120904171330.f6b0a922a754ba0f3acc123b@canb.auug.org.au>
In-Reply-To: <20120904171330.f6b0a922a754ba0f3acc123b@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 12:13 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120824:
> 



drivers/base/dma-contiguous.c:351:3: error: expected ';' before '}' token


		} else if (ret != -EBUSY) {
>>>			break
		}


-- 

~Randy
