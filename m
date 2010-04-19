Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab0DSHUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 03:20:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49388 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0DSHUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 03:20:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Yw1MwlYGckNEwWss24Pmc0X5eNvgLNNOe0WDk35wO/V4F9M1anUSb+n1lhBlfeLZdM
         ZDNiH1LLzyw5OeGiS/te3N9K7Y7R5qxCgRwVYAsz+3jWrgfVdaeOfahaYF5P2vhUDSXn
         J2D0lYk4AlCrh0wnbpooFwVvjfNlCvwr2Jcpk=
Message-ID: <4BCC0453.3060806@gmail.com>
Date: Mon, 19 Apr 2010 00:20:51 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jie Zhang <jie@codesourcery.com>
CC: Ben Gamari <bgamari.foss@gmail.com>, gcc@gcc.gnu.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: gcc- 4.6.0 20100416 rtmutex.c:1138:1: internal compiler error
References: <i2ydd18b0c31004182119w30322238p2ab0094f55901051@mail.gmail.com> <4bcbebb3.9653f10a.3be1.ffffe0ef@mx.google.com> <4BCBFBA9.9040606@gmail.com> <4BCBFEE3.8020509@codesourcery.com>
In-Reply-To: <4BCBFEE3.8020509@codesourcery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2010 11:57 PM, Jie Zhang wrote:
> On 04/19/2010 02:43 PM, Justin P. Mattock wrote:
>> I couldn't resist..(had to play),
>> anyways I looked through the reports
>> but didn't see anything that was
>> familiar. so I went and created an entry:
>> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43791
>>
> Thanks. Please add a preprocessed source file so people can reproduce
> your issue.
>
>


as for the preprocessed source file,
not that yet skilled at code.(one day)
I added my .config, and the CFLAGS
I used for building gcc.

In regards to 4.6.0 everything seems
o.k. i.g. glibc builds with no errors
all of the xserver no errors, even firefox
builds.. seems the kernel was the only real
problem I ran into(which isn't really a problem
given this version of gcc is experimental).

maybe something todo with building modules
(but could be wrong).

Justin P. Mattock
