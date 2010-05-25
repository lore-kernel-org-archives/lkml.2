Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161Ab0EYUc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:32:27 -0400
Received: from bluebox.CS.Princeton.EDU ([128.112.136.38]:39114 "EHLO
	bluebox.CS.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab0EYUc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:32:26 -0400
Subject: Re: [stable] Boot failure with 2.6.27.46 on Xeon E5620 (Westmere EP)
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=utf-8
From: "=?utf-8?Q?=22S.=C3=87a=C4=9Flar_Onur=22?=" <caglar@CS.Princeton.EDU>
In-Reply-To: <20100525155307.GA7453@kroah.com>
Date: Tue, 25 May 2010 16:32:16 -0400
Cc: stable@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Content-Transfer-Encoding: 8BIT
Message-Id: <620C3556-2708-4704-90F3-37DDEF1A404E@CS.Princeton.EDU>
References: <000954C6-B4AC-4FD8-BA3B-C3B199C7607F@CS.Princeton.EDU> <20100525155307.GA7453@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1078)
X-Proofpoint-Virus-Version: vendor=nai engine=5400 definitions=5993 signatures=621968
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On May 25, 2010, at 11:53 AM, Greg KH wrote:

> On Tue, May 25, 2010 at 11:10:28AM -0400, "S.Çağlar Onur" wrote:
>> Hi,
>> 
>> We are observing boot failures [1] & [2] on some of our servers (Dell
>> r410) with 2.6.27-stable kernels. I found following commit in upstream
>> tree via a quick search (but I haven't tried it yet) so I don't know
>> whether I'm on the right track or not. 
>> 
>> Please let me know if anything else is needed...
> 
> Has any .27 kernel worked on these machines?  If so, can you narrow it
> down to the patch that caused the problem?

I don't think any .27 kernel worked on those machines before. But in any case I'll try (I don't have a physical access to those machines as they are located in China) an older .27 release to see.

> thanks,
> 
> greg k-h


Best regards,
--
S.Çağlar Onur <caglar@cs.princeton.edu>

