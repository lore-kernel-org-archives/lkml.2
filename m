Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab2DYQjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:39:16 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54607 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab2DYQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:39:15 -0400
Message-ID: <4F982862.4050302@linux.vnet.ibm.com>
Date: Wed, 25 Apr 2012 11:37:54 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/6] zsmalloc: make zsmalloc portable
References: <1335334994-22138-1-git-send-email-minchan@kernel.org> <1335334994-22138-7-git-send-email-minchan@kernel.org> <4F980AFE.60901@vflare.org>
In-Reply-To: <4F980AFE.60901@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042516-6148-0000-0000-000005503097
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Minchan,

Thanks for the patches!

On 04/25/2012 09:32 AM, Nitin Gupta wrote:
> I think Seth was working on this improvement but not sure about the
> current status. Seth?

Yes, I looked at this option, and it is very clean and portable.

Unfortunately, IIRC, with our rate of mapping/unmapping,
flush_tlb_kernel_range() causes an IPI storm that effective
stalls the machine.

I'll apply your patch and try it out.

Thanks,
Seth

