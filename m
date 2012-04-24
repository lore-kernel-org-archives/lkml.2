Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2DXNay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:30:54 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48938 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2DXNax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:30:53 -0400
Message-ID: <4F96AAF4.2000402@linux.vnet.ibm.com>
Date: Tue, 24 Apr 2012 08:30:28 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Autif Khan <autif.mlist@gmail.com>
Subject: Re: [PATCH] drivers: staging: zcache: fix Kconfig crypto dependency
References: <1335231230-29344-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120424022702.GA6573@kroah.com>
In-Reply-To: <20120424022702.GA6573@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042413-3352-0000-0000-0000043C779C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 09:27 PM, Greg Kroah-Hartman wrote:
> Ok, this fixes one of the build problems reported, what about the other
> one?

Both problems that I heard about were caused by same issue;
the issue fixed in this patch.

ZSMALLOC=m was only allowed because CRYPTO=m was allowed.
This patch requires CRYPTO=y, which also requires ZSMALLOC=y
when ZCACHE=y.

https://lkml.org/lkml/2012/4/19/588

https://lkml.org/lkml/2012/4/23/481

Thanks,
Seth

