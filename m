Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab0LQDZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:25:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55609 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab0LQDZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:25:21 -0500
Message-ID: <4D0AD7FF.5020103@zytor.com>
Date: Thu, 16 Dec 2010 19:24:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [BUG]x86: relocatable doesn't work with new binutils
References: <1292553726.2323.482.camel@sli10-conroe>	 <4D0AD1F9.7030704@zytor.com> <1292556114.2323.484.camel@sli10-conroe>
In-Reply-To: <1292556114.2323.484.camel@sli10-conroe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 07:21 PM, Shaohua Li wrote:
> On Fri, 2010-12-17 at 10:59 +0800, H. Peter Anvin wrote:
>> On 12/16/2010 06:42 PM, Shaohua Li wrote:
>>> We can easily workaround this issue by moving jiffies to a section or at
>>> least warn people if such binutils are using. what should we do?
>>
>> I think we should do the workaround, but still get distros to update the
>> broken binutils.
> Here is my workaround.
> The problem is a lot of kernel versions are affected by this, fix all?

I suspect the stable kernels should be able to take the patch easily enough.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

