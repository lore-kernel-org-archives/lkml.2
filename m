Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab1DAK4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 06:56:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56225 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab1DAK4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 06:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fw1kV7YeaH9v8poClQTf6SNhU42qdhktqozW2RTwVRINkL59+ZY7nVRlQxjJl+gboy
         ktCZwiiAsQN+G7kM4JAuqbdatlz1EWu7jdL7XyXu5twVV3h082K7fXuHY/bQhVD0G237
         kosO9rtdYgLev7dhvGsriASeLEk6+lFvvwHlE=
MIME-Version: 1.0
In-Reply-To: <20110331162438.3225d7a4@lxorguk.ukuu.org.uk>
References: <AANLkTi=aT2-ugOhDdSuh241PF-Sz-fFL1BkCUahoq0+o@mail.gmail.com>
	<20110331162438.3225d7a4@lxorguk.ukuu.org.uk>
Date: Fri, 1 Apr 2011 16:26:11 +0530
Message-ID: <AANLkTink2gPzby3Ad-ZD2o33K9iAYPZq=D2wNGH=3Oa7@mail.gmail.com>
Subject: Re: GPL License Query on a Plain Linux Application
From: Ramya Desai <ramya.desai@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 8:54 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 31 Mar 2011 20:49:34 +0530
> Ramya Desai <ramya.desai@gmail.com> wrote:
>
>> Dear All,
>>
>> I have written an application where it uses plain system calls like
>> open, read, write etc. and runs in the user space. My question here,
>> is this application comes under GPL?
>
> This is a technical not a legal list - I would ask the Linux Foundation
> if you want a legal answer.
>
> In general though your question seems really to be "is my application a
> derivative work of the kernel". That would be a surprising interpretation
> (speaking as a non-lawyer) but also one the community wanted to be sure
> never occurred. Hence the COPYING file for the kernel itself states:
>
>   NOTE! This copyright does *not* cover user programs that use kernel
>  services by normal system calls - this is merely considered normal use
>  of the kernel, and does *not* fall under the heading of "derived work".
>  Also note that the GPL below is copyrighted by the Free Software
>  Foundation, but the instance of code that it refers to (the Linux
>  kernel) is copyrighted by me and others who actually wrote it.

Dear Alan,

Thanks for your valuable information. I got what I need.

Thanks and Regards,
Ramya.

>
> Alan
>
