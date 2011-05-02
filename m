Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab1EBSd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 14:33:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40271 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab1EBSdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 14:33:25 -0400
Message-ID: <4DBEF8EC.7080301@zytor.com>
Date: Mon, 02 May 2011 11:33:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xensource.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com
Subject: Re: [Xen-devel] Re: [PATCH] Two patches fixing regression introduced
 by 'x86-64, mm: Put early page table high'
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com> <4DBEEA69.7010000@zytor.com> <20110502180802.GA7498@dumpdata.com>
In-Reply-To: <20110502180802.GA7498@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2011 11:08 AM, Konrad Rzeszutek Wilk wrote:
>>
>> My inclination would be to apply your workaround -- are there any
>> adverse effects to doing that?
> 
> There is a bootup slowdown (not noticeable). That is because we call the
> 'memblock_find_range' function on every PTE table creation (only during
> bootup of course). 
> 
> Testing wise, on the machines on which the regression occurred, with these two
> patches the regression disappears - so that is a good sign. I am testing
> it on some more today to assure myself I am not missing anything.
> 

OK, sounds like a plan then.  I like it because it doesn't affect the
native kernel.

	-hpa
