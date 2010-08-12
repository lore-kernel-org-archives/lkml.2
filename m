Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221Ab0HLQct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:32:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31431 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0HLQcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:32:48 -0400
Message-ID: <4C6421D3.9050201@oracle.com>
Date: Thu, 12 Aug 2010 09:31:15 -0700
From: Randy Dunlap <randy.dunlap@ORACLE.COM>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Pistis Valentino <vale.pistis@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problems Compile Misc Module Example
References: <AANLkTimGwbP8_fachx9pwTyX1wZxxT1iGrKziWMmxunL@mail.gmail.com> <20100811165403.6713d206.randy.dunlap@oracle.com> <AANLkTi=D+ZAkg1PYHH-t4u4LFFoY9zOX+DpA_xMU=bY=@mail.gmail.com> <AANLkTimkYhwVy3XdMvBb9oqVVOFb9MSjivrMfgM+B7_w@mail.gmail.com> <4C641D56.9000309@oracle.com> <AANLkTimWb9uXxdbfusDLcPqA60_VVz-V264_-3CWJ4HW@mail.gmail.com>
In-Reply-To: <AANLkTimWb9uXxdbfusDLcPqA60_VVz-V264_-3CWJ4HW@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/10 09:25, Pistis Valentino wrote:
> 2010/8/12 Randy Dunlap <randy.dunlap@oracle.com>:
>> On 08/12/10 09:09, Pistis Valentino wrote:
>>> Hello,
>>>
>>> to be fair, I write how I solved my problem:
>>>
>>> i have 2 files driver_ase.c and driver_ase.h.
>>>
>>> Inside a .h file there was some declarations includes for kernel
>>> headers used only by driver_ase.c.
>>> This includes declarations make a problems during compile the service_ase.c.
>>>
>>> In other words the problem is not in the kernel, but is my C (header)
>>> kow-how  problem.
>>
>> Glad to hear that you have solved this.
>>
>>> Sorry
>>>
>>> Ciao
>>> Vale
>>>
>>> P.S. Make and Compile the kernel modules it's very hard! lacks a
>>> coherent and updated documentation for non-experts.
>>>
>>
>> Well, we try, but if you would like to add some documentation on it,
>> please send it.
>>
> 
> Your work is precious and very great!
> Thank you so much!
> 
> Within a few days will send a brief documentation on my work-example
> and the precautions I had taken.
> So who has never written a sample driver from scratch will avoid the
> problems I found.
> 
> Show me where it is ok to send the doc on this mailing list.

It's OK!

Please also copy the linux-doc@vger.kernel.org mailing list on it.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
