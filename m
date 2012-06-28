Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab2F1R4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:56:17 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56386 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab2F1R4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:56:13 -0400
Message-ID: <4FEC7668.3000403@linux.vnet.ibm.com>
Date: Thu, 28 Jun 2012 10:21:12 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Konrad Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com> <4FEA9FDD.6030102@kernel.org> <4FEAA4AA.3000406@intel.com> <4FEAA7A1.9020307@kernel.org> <90bcc2c8-bcac-4620-b3c0-6b65f8d9174d@default> <4FEB5204.3090707@linux.vnet.ibm.com> <4FEBBB5C.5000505@intel.com>
In-Reply-To: <4FEBBB5C.5000505@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062817-7408-0000-0000-0000064F7130
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 09:03 PM, Alex Shi wrote:
> Peter Anvin is merging my TLB patch set into tip tree, x86/mm branch.

Great! I don't know the integration path of this tree.  Will
these patches go into mainline in the next merge window from
here?

--
Seth

