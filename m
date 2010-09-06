Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0IFRNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 13:13:21 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44685 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab0IFRNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 13:13:16 -0400
Message-ID: <4C852128.3040708@canonical.com>
Date: Mon, 06 Sep 2010 10:13:12 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: apparmor: double lock
References: <4C823419.6050906@gmail.com> <4C832DA6.8070707@canonical.com> <alpine.LRH.2.00.1009061029170.9229@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1009061029170.9229@tundra.namei.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2010 05:29 PM, James Morris wrote:
> On Sat, 4 Sep 2010, John Johansen wrote:
> 
>> On 09/04/2010 04:57 AM, Jiri Slaby wrote:
>>> Hi,
>>>
>>> stanse found that you possibly double lock ns->lock:
>>> aa_remove_profiles
>>>   -> write_lock(&ns->lock)
>>>   -> __remove_namespace(ns)
>>>     -> destroy_namespace(ns)
>>>       -> write_lock(&ns->lock)
>>>
>>> Could you fix that if that may happen at all?
>>>
>> Yes, thanks Jiri, the patch has already been posted
>>
>> http://marc.info/?l=linux-kernel&m=128295924407596&w=2
> 
> Are all of the patches in that set ready to be merged to Linus?
> 
yes they should be now, I believe so.

I have just posted out the updated  Fix security_task_setrlimit logic
patch that fixes the commenting.  I can repost the series if you would
like.

thanks
john
