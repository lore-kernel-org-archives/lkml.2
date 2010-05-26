Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab0EZD3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 23:29:17 -0400
Received: from bluebox.CS.Princeton.EDU ([128.112.136.38]:38723 "EHLO
	bluebox.CS.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab0EZD3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 23:29:15 -0400
Subject: Re: [stable] Boot failure with 2.6.27.46 on Xeon E5620 (Westmere EP)
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=utf-8
From: "=?utf-8?Q?=22S.=C3=87a=C4=9Flar_Onur=22?=" <caglar@CS.Princeton.EDU>
In-Reply-To: <1274833451.2892.574.camel@sbs-t61.sc.intel.com>
Date: Tue, 25 May 2010 23:29:04 -0400
Cc: Greg KH <greg@kroah.com>, "stable@kernel.org" <stable@kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Song, Youquan" <youquan.song@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <DD6ACA75-527D-406D-971B-64F042E0ED26@CS.Princeton.EDU>
References: <000954C6-B4AC-4FD8-BA3B-C3B199C7607F@CS.Princeton.EDU> <20100525155307.GA7453@kroah.com> <620C3556-2708-4704-90F3-37DDEF1A404E@CS.Princeton.EDU> <20100525205123.GA14993@kroah.com> <1274833451.2892.574.camel@sbs-t61.sc.intel.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
X-Mailer: Apple Mail (2.1078)
X-Proofpoint-Virus-Version: vendor=nai engine=5400 definitions=5993 signatures=621968
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suresh,

On May 25, 2010, at 8:24 PM, Suresh Siddha wrote:

> On Tue, 2010-05-25 at 13:51 -0700, Greg KH wrote:
>> On Tue, May 25, 2010 at 04:32:16PM -0400, "S.Çağlar Onur" wrote:
>>> Hi Greg,
>>> 
>>> On May 25, 2010, at 11:53 AM, Greg KH wrote:
>>> 
>>>> On Tue, May 25, 2010 at 11:10:28AM -0400, "S.Çağlar Onur" wrote:
>>>>> Hi,
>>>>> 
>>>>> We are observing boot failures [1] & [2] on some of our servers (Dell
>>>>> r410) with 2.6.27-stable kernels. I found following commit in upstream
>>>>> tree via a quick search (but I haven't tried it yet) so I don't know
>>>>> whether I'm on the right track or not. 
>>>>> 
>>>>> Please let me know if anything else is needed...
>>>> 
>>>> Has any .27 kernel worked on these machines?  If so, can you narrow it
>>>> down to the patch that caused the problem?
>>> 
>>> I don't think any .27 kernel worked on those machines before. But in
>>> any case I'll try (I don't have a physical access to those machines as
>>> they are located in China) an older .27 release to see.
>> 
>> Ok, so it isn't a regression, which is what I want to know.
>> 
>> New hardware like this, probably will only work on newer kernel
>> versions, so please use those instead :)
> 
> I can't think of any known issues in 2.6.27 that can lead to this kind
> of boot failure on WSM-EP. Caglar, It will be nice if you can do git
> bisect between working and non-working kernels.

Sure, I'll try to boot those with plain 2.6.27 to see but please note that it's going to be little time consuming. For each one I have to create a custom boot image for them to download and test (a.k.a. don't expect to hear from me soon :))

> thanks,
> suresh


Best regards,
--
S.Çağlar Onur <caglar@cs.princeton.edu>

