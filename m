Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726Ab2HJSPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 14:15:15 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37696 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758857Ab2HJSPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 14:15:11 -0400
Message-ID: <50254F69.2000409@linux.vnet.ibm.com>
Date: Fri, 10 Aug 2012 13:14:01 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kurt Hackel <kurt.hackel@oracle.com>
Subject: Re: [PATCH 0/4] promote zcache from staging
References: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com> <5021795A.5000509@linux.vnet.ibm.com> <5024067F.3010602@linux.vnet.ibm.com> <2e9ccb4f-1339-4c26-88dd-ea294b022127@default>
In-Reply-To: <2e9ccb4f-1339-4c26-88dd-ea294b022127@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081018-5806-0000-0000-0000183EFF3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 03:20 PM, Dan Magenheimer wrote
> I also wonder if you have anything else unusual in your
> test setup, such as a fast swap disk (mine is a partition
> on the same rotating disk as source and target of the kernel build,
> the default install for a RHEL6 system)?

I'm using a normal SATA HDD with two partitions, one for
swap and the other an ext3 filesystem with the kernel source.

> Or have you disabled cleancache?

Yes, I _did_ disable cleancache.  I could see where having
cleancache enabled could explain the difference in results.

> Or have you changed any sysfs parameters or
> other kernel files?

No.

> And are you using 512M of physical memory or relying on
> kernel boot parameters to reduce visible memory

Limited with mem=512M boot parameter.

> ... and
> if the latter have you confirmed with /proc/meminfo?

Yes, confirmed.

Seth

