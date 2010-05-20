Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab0ETH1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:27:34 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:65260 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0ETH1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=N+ubhBnWFvhsAJFYwcXT4dNjmzZembLz3UXjLikBp0MnNEfW4iBWVvFqRKwnuo7lHb
         RurPOnkxPed8iwtu+fSoK/sfpCtiPYEkzlJyb7S9tyRnZa3AVnO5FVH4wYp3h74Lu19M
         mw/PjhipSXRJi1CIE9+lGR+GBZQa20lw/CYz0=
MIME-Version: 1.0
In-Reply-To: <AANLkTimUYmUCdFMIaVi1qqcz2DqGoILeu43XWZBHSILP@mail.gmail.com>
References: <AANLkTimAF1zxXlnEavXSnlKTkQgGD0u9UqCtUVT_r9jV@mail.gmail.com> 
	<AANLkTimUYmUCdFMIaVi1qqcz2DqGoILeu43XWZBHSILP@mail.gmail.com>
From: dave b <db.pub.mail@gmail.com>
Date: Thu, 20 May 2010 17:27:10 +1000
Message-ID: <AANLkTilmr29Vv3N64n7KVj9fSDpfBHIt8-quxtEwY0_X@mail.gmail.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a reason - no one has taken any interesting in my email ?....
 The behaviour isn't found on the 2.6.26 debian kernel. So I was
thinking that it might be due to my intel graphics card / memory
interplay ? ....

On 14 May 2010 23:14, dave b <db.pub.mail@gmail.com> wrote:
> On 14 May 2010 22:53, dave b <db.pub.mail@gmail.com> wrote:
>> In 2.6.3* kernels (test case was performed on the 2.6.33.3 kernel)
>> when physical memory runs out and there is a large swap partition -
>> the system completely stalls.
>>
>> I noticed that when running debian lenny using dm-crypt  with
>> encrypted / and swap with a  2.6.33.3 kernel (and all of the 2.6.3*
>> series iirc) when all physical memory is used (swapiness was left at
>> the default 60) the system hangs and does not respond. It can resume
>> normal operation some time later - however it seems to take a *very*
>> long time for the oom killer to come in. Obviously with swapoff this
>> doesn't happen - the oom killer comes in and does its job.
>>
>>
>> free -m
>>             total       used       free     shared    buffers     cached
>> Mem:          1980       1101        879          0         58        201
>> -/+ buffers/cache:        840       1139
>> Swap:        24943          0      24943
>>
>>
>> My simple test case is
>>
>> dd if=/dev/zero of=/tmp/stall
>> and wait till /tmp fills...
>>
>
> Sorry - I forgot to say I am running x86-64
>
