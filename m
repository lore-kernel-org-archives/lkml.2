Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab1JFGwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:52:31 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33492 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1JFGw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:52:28 -0400
Message-ID: <4E8D5028.3080406@linux.vnet.ibm.com>
Date: Thu, 06 Oct 2011 12:22:24 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Pavel Ivanov <paivanof@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Full lockup when compiling kernel with "optimal" number of threads
References: <CAG1a4rvdYnOSWu3DJ+DL+Q_bfsfTv_px20vP06fBKRm6B8cwMw@mail.gmail.com> <4E8982E3.9080809@linux.vnet.ibm.com> <CAG1a4rvYX9P+vHTLQBV_edViU8QriT=mrut0c5oS5YZ96L3x=A@mail.gmail.com>
In-Reply-To: <CAG1a4rvYX9P+vHTLQBV_edViU8QriT=mrut0c5oS5YZ96L3x=A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 03:13 AM, Pavel Ivanov wrote:
> On Mon, Oct 3, 2011 at 5:39 AM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> On 09/03/2011 09:04 AM, Pavel Ivanov wrote:
>>> Hi,
>>>
>>> I can reliably reproduce a complete machine lockup when compiling
>>> kernel sources with "make -j". After making some progress machine
>>> stops responding to anything (including CapsLock/NumLock switching or
>>> mouse moving) and after hard reboot nothing is left in kern.log or
>>> syslog. Only attaching a serial console gives me the following clues
>>> to what happens:
>>>
>> By the way "optimal" is supposed to be make -j <nr_cpus*2> isn't it?
>> IIRC, "maximal" refers to make -j
> 
> I'm sure I didn't make up that word "optimal" by myself. I took it
> from some documentation or internet, although now I can't find where I
> took it from. Wherever I look it says that -j is "unbounded" number of
> threads.
> 

I was referring to the terms used by kernbench.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
