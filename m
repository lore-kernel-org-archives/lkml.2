Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab0DSVRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:17:14 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58276 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab0DSVRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GbVKcjvJUdpEPdtwbzkiIyCeFE3DojL1CHocNoVC3W2rYCjMVJrGC7bGbYi//APBVs
         8vQQptiFEmqvNuYCAtkMAwBMmoO4ef7n1AsNFR6N9Yjw9v8CtgUiEWLaOGhMDESu69oA
         5MalT54h2Xg6mL2aJoLiRlfM5GzDQD/QV9tII=
MIME-Version: 1.0
In-Reply-To: <4BCC0453.3060806@gmail.com>
References: <i2ydd18b0c31004182119w30322238p2ab0094f55901051@mail.gmail.com>
	 <4bcbebb3.9653f10a.3be1.ffffe0ef@mx.google.com>
	 <4BCBFBA9.9040606@gmail.com> <4BCBFEE3.8020509@codesourcery.com>
	 <4BCC0453.3060806@gmail.com>
Date: Mon, 19 Apr 2010 22:17:11 +0100
Message-ID: <r2s4348dea51004191417yd5915c1du89b179011d65ca5f@mail.gmail.com>
Subject: Re: gcc- 4.6.0 20100416 rtmutex.c:1138:1: internal compiler error
From: Jonathan Wakely <jwakely.gcc@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Jie Zhang <jie@codesourcery.com>, Ben Gamari <bgamari.foss@gmail.com>,
       gcc@gcc.gnu.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 April 2010 08:20, Justin P. Mattock wrote:
> On 04/18/2010 11:57 PM, Jie Zhang wrote:
>>
>> On 04/19/2010 02:43 PM, Justin P. Mattock wrote:
>>>
>>> I couldn't resist..(had to play),
>>> anyways I looked through the reports
>>> but didn't see anything that was
>>> familiar. so I went and created an entry:
>>> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43791
>>>
>> Thanks. Please add a preprocessed source file so people can reproduce
>> your issue.
>>
>>
>
>
> as for the preprocessed source file,
> not that yet skilled at code.(one day)

See the "how to report" link on the gcc front page:
http://gcc.gnu.org/bugs/
It's not hard.
