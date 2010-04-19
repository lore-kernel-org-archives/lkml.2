Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab0DSVg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:36:57 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:50874 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0DSVg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:36:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HgmhjJTXK24BP14Fk4FNY63fwFlUKIfn0QBpe2eREUAYzOkoLT2ERYcj5+84qAgzay
         zmyIqkBUUk2DZ8dKIV02/uf3Jj0rYCw/3ctmuWC8OzhRHj/fuAFD6fgirvKPNji5pG8M
         i/RCIXS8ZC9Q72jwFBzzjZgxkmOt3ZKUQA/3U=
Message-ID: <4BCCCD4B.2070906@gmail.com>
Date: Mon, 19 Apr 2010 14:38:19 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jonathan Wakely <jwakely.gcc@gmail.com>
CC: Jie Zhang <jie@codesourcery.com>, Ben Gamari <bgamari.foss@gmail.com>,
       gcc@gcc.gnu.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: gcc- 4.6.0 20100416 rtmutex.c:1138:1: internal compiler error
References: <i2ydd18b0c31004182119w30322238p2ab0094f55901051@mail.gmail.com>	 <4bcbebb3.9653f10a.3be1.ffffe0ef@mx.google.com>	 <4BCBFBA9.9040606@gmail.com> <4BCBFEE3.8020509@codesourcery.com>	 <4BCC0453.3060806@gmail.com> <r2s4348dea51004191417yd5915c1du89b179011d65ca5f@mail.gmail.com>
In-Reply-To: <r2s4348dea51004191417yd5915c1du89b179011d65ca5f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 02:17 PM, Jonathan Wakely wrote:
> On 19 April 2010 08:20, Justin P. Mattock wrote:
>> On 04/18/2010 11:57 PM, Jie Zhang wrote:
>>>
>>> On 04/19/2010 02:43 PM, Justin P. Mattock wrote:
>>>>
>>>> I couldn't resist..(had to play),
>>>> anyways I looked through the reports
>>>> but didn't see anything that was
>>>> familiar. so I went and created an entry:
>>>> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43791
>>>>
>>> Thanks. Please add a preprocessed source file so people can reproduce
>>> your issue.
>>>
>>>
>>
>>
>> as for the preprocessed source file,
>> not that yet skilled at code.(one day)
>
> See the "how to report" link on the gcc front page:
> http://gcc.gnu.org/bugs/
> It's not hard.
>


the info from jie, worked, as well
as: make kernel/rtmutex.i
(from joe perches)

Justin P. Mattock
