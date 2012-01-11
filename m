Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab2AKKKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 05:10:21 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53434 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab2AKKKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:10:19 -0500
Message-ID: <4F0D6006.40506@canonical.com>
Date: Wed, 11 Jan 2012 11:10:14 +0100
From: Tim Gardner <rtg.canonical@gmail.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20111223 Thunderbird/10.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Latest kernel stable/longterm status
References: <20120110003705.GA9482@kroah.com> <20120110022617.GA11376@home.goodmis.org> <4F0C0CF5.1080706@gmail.com> <20120110235612.GB1507@kroah.com>
In-Reply-To: <20120110235612.GB1507@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 12:56 AM, Greg KH wrote:
> On Tue, Jan 10, 2012 at 11:03:33AM +0100, Tim Gardner wrote:
>> On 01/10/2012 03:26 AM, Steven Rostedt wrote:
>>> On Mon, Jan 09, 2012 at 04:37:05PM -0800, Greg KH wrote:
>>>> As 3.2 is now out, here's a note as to the current status of the
>>>> different stable/longterm kernel trees.
>>>
>>> Thanks for all your hard work Greg!
>>>
>>
>> I'd also like to thank Greg.
>>
>> Ubuntu will continue to support 2.6.32.y until April 2015. Ubuntu
>> has also chosen 3.2 as a long term supported kernel for the 12.04
>> release and will pick up support for it when 3.3 is released.
>
> What exactly do you mean by this?
>
> greg k-h

If you're agreeable, I would very much prefer to continue with the 
stable update model that you've developed by committing to the 
linux-2.6.32.y and linux-3.2.y branches in 
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git. 
The mailing list review process as well as the policies regarding patch 
suitability are working well.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
