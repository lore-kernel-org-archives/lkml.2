Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1AUWjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:39:35 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58337 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1AUWjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:39:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=L+J96Xsvop3kt6Vp70MButmX5eGIZvY/Ddm7+gRG7QhhrDEAZd5FBkFdlFS94af1f0
         99U8YcFrd0wT+bTpoY1XduLZQi8FHJz/nGIitz8uZV6T3ZUTFDK/Oru0FCUECBZkxSfB
         zwzVF35PEIf6S5d5jwsQXspKzDpkTGFuP29cg=
MIME-Version: 1.0
In-Reply-To: <1295648870.23779.15.camel@marge.simson.net>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com> <1295648870.23779.15.camel@marge.simson.net>
From: Michael Witten <mfwitten@gmail.com>
Date: Fri, 21 Jan 2011 16:39:03 -0600
Message-ID: <AANLkTini15poUNM54UrM5KmGAoyJOznReYAFCkoxKEyN@mail.gmail.com>
Subject: Re: 'autogroup' sched code KILLING responsiveness
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 16:27, Mike Galbraith <efault@gmx.de> wrote:
> On Fri, 2011-01-21 at 10:20 -0800, Michael Witten wrote:
>> Bisecting shows that this commit:
>>
>>   5091faa449ee0b7d73bc296a93bca9540fc51d0a
>>   sched: Add 'autogroup' scheduling feature: automated per session task groups
>>   Date:   Tue Nov 30 14:18:03 2010 +0100
>>
>> is the reason that my computer has become unusable.
>>
>> With that code in place, a resource-intensive activity (such as
>> compiling the Linux kernel) causes my computer to become
>> unresponsive for many seconds at a time; the entire screen
>> does not refresh, typed keys are dropped or are handled very
>> late, etc (even in Linux's plain virtual consoles).
>
> That's not what I'm experiencing with a UP kernel...

Before I try to gather any data, I'd like to point out that the
problem disappears when I disable CONFIG_SCHED_AUTOGROUP (General
setup -> Automatic process group scheduling).

Do you have it disabled?
