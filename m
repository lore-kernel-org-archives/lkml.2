Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab2JRPBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:01:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45677 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab2JRPBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:01:42 -0400
Message-ID: <508019C8.4030902@zytor.com>
Date: Thu, 18 Oct 2012 08:01:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/4] x86/wakeup/sleep: Check whether the TSS GDT descriptor
 is empty before using it.
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com> <1350481786-4969-2-git-send-email-konrad.wilk@oracle.com> <507F473D.1060700@zytor.com> <20121018144709.GB19782@localhost.localdomain>
In-Reply-To: <20121018144709.GB19782@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 07:47 AM, Konrad Rzeszutek Wilk wrote:
>>
>> Why is this patch necessary?  Presumably there is something further
>> down the line which depends on the TSS descriptor being empty, but
>> if so, what?
>
> I could not find it. This write has been in the code since the initial
> git history. Is the pre-git bitkeeper tree somewhere available?

I didn't ask why the write was necessary, but why you need it to be 
conditional.

I know why the write is necessary: it is (presumably) there to clear the 
TSS busy bit.

However, as for older records:

-bk era history (2.5.0-2.6.12-rc2):
git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git

Ancient history (pre-2.4.0):
git://git.kernel.org/pub/scm/linux/kernel/git/davej/history.git

There doesn't seem to be any git trees known for the bridge between 
2.4.0 and 2.5.0.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

