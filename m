Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab2IDULl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:11:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41777 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932669Ab2IDULi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:11:38 -0400
Message-ID: <5046606B.7000705@linux.vnet.ibm.com>
Date: Tue, 04 Sep 2012 15:11:23 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 0/3] promote zcache from staging
References: <1346788969-4100-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120904195711.GC12469@phenom.dumpdata.com>
In-Reply-To: <20120904195711.GC12469@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090420-3534-0000-0000-00000C3C0808
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 02:57 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Sep 04, 2012 at 03:02:46PM -0500, Seth Jennings wrote:
>> zcache is the remaining piece of code required to support in-kernel
>> memory compression.  The other two features, cleancache and frontswap,
>> have been promoted to mainline in 3.0 and 3.5 respectively.  This
>> patchset promotes zcache from the staging tree to mainline.
> 
> Could you please post it as a singular path. As if it was out-off-tree?
> That way it will be much easier to review it by looking at the full code.

Ah yes, my bad. Scratch v2. Nothing to see here.

Seth

