Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527Ab2ERBs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 21:48:27 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:55882 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762496Ab2ERBs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 21:48:26 -0400
Message-ID: <1337305553.1844.3.camel@ubuntu.ubuntu-domain>
Subject: Re: [PATCH v2 1/3] zsmalloc: support zsmalloc to ARM, MIPS, SUPERH
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Chen Liqin <liqin.chen@sunplusct.com>
Date: Fri, 18 May 2012 09:45:53 +0800
In-Reply-To: <4FB4B109.9000703@kernel.org>
References: <1337133919-4182-1-git-send-email-minchan@kernel.org>
	  <1337153329.1751.5.camel@ubuntu.ubuntu-domain>
	  <4FB44147.5070704@kernel.org>
	 <1337216199.1837.11.camel@ubuntu.ubuntu-domain>
	 <4FB4B109.9000703@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 17:04 +0900, Minchan Kim wrote:

> ...
> I don't think so.
> It's terrible experience if all users have to look up local_flush_tlb_kernel_range of arch for using zsmalloc.
> 
> BTW, does unicore32 support that function?
> If so, I would like to add unicore32 in Kconfig.
> 
Yes. Thanks.

Could you give me some materials on performance and testsuite?


Guan Xuetao

