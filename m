Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1AYPKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:10:53 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:48373 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1AYPKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:10:52 -0500
Message-ID: <4D3EE7F6.9080904@linux.vnet.ibm.com>
Date: Tue, 25 Jan 2011 20:40:46 +0530
From: Anithra P Janakiraman <anithra@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/0] Panic on softdog timeout
References: <4D358B34.7040902@linux.vnet.ibm.com> <1295368527.31327.193.camel@nimitz>
In-Reply-To: <1295368527.31327.193.camel@nimitz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2011 10:05 PM, Dave Hansen wrote:
> On Tue, 2011-01-18 at 18:14 +0530, Anithra P Janakiraman wrote:
>    
>> We currently have no way of determining the reason for failure when a
>> softdog timeout occurs. At the minimum a snapshot of the system would
>> help to determine the cause.
>> The attached patch invokes panic on softdog timeout iff kdump is
>> configured, if kdump is not configured it works as usual.
>>      
> This sounds like a decent idea.  But, is it something that should be a
> bit more optional?  We currently have boot options for when to reboot or
> panic for other things, and this is really the first use of
> kexec_crash_image outside of kexec itself.  Is it really the best switch
> to use?
>
> Will this break anyone who expects a quick, clean, reboot and instead
> gets a kdump?  Should we make _all_ emergency_restart()s use kdump?
>
> You might have noticed, but your subject is a little wonky.  It should
> probably just omit the 1/1 stuff when you only have a single patch
> series.  The subject is pretty short and doesn't really explain what's
> going on.  Could you beef it up a bit?
>
>    
>

Thanks for looking at it and for the comments. I've sent a
version 2 of the patch that hopefully addresses all your
comments.

link:
http://permalink.gmane.org/gmane.linux.kernel/1091282

For some strange reason i'm unable to find a link to my
mail on lkml.org. I see emails only upto the 23rd of Jan.

Regards,
Anithra.


