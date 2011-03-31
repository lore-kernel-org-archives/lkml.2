Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab1CaAtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 20:49:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64709 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab1CaAts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 20:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LeGQmGjadTcnds5ATRSAoTU6/ENjERFz4gpSvvXiSikWxeHFtrseUvYeIjYVe9Mv+F
         VI0zpQMmsCDAgGIr+8MRGKHxqYSt/zxtxfijHa+A8nN39Sx2olTjYu3oblEiAr3FdYck
         OqzKsvP9iGwM2DZkN0FIG0xo1O2ZdsktN5Lfg=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=fQsrVTo=dA03_75j_++Ya4-M1sd8T-9Lb1tPQ@mail.gmail.com>
References: <1299990249-18264-1-git-send-email-bgat@billgatliff.com>
 <1299990249-18264-2-git-send-email-bgat@billgatliff.com> <AANLkTik1_Eekn7e0H+czCWHUX8LdioPH8MSHjcoZG6B=@mail.gmail.com>
 <AANLkTi=fQsrVTo=dA03_75j_++Ya4-M1sd8T-9Lb1tPQ@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 30 Mar 2011 20:49:27 -0400
Message-ID: <AANLkTi=o3TCBOhd8gV5=2TOkL1eTrwXJqArLy7PLTkGC@mail.gmail.com>
Subject: Re: [PWM v8 1/3] PWM: Implement a generic PWM framework
To: Bill Gatliff <bgat@billgatliff.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 20:43, Bill Gatliff wrote:
> On Wed, Mar 30, 2011 at 6:57 PM, Mike Frysinger wrote:
>> On Sat, Mar 12, 2011 at 23:24, Bill Gatliff wrote:
>>> +T:     git git://git.billgatliff.com/pwm.git
>>
>> $ git clone git://git.billgatliff.com/pwm.git
>> Cloning into pwm...
>> fatal: The remote end hung up unexpectedly
>
> I just tried http://git.billgatliff.com/pwm.git, and that's working.
> FWIW.  I don't know why git:// has suddenly stopped working...

seems to be working, albeit with significantly more overhead.  i guess
a one-off fetch is fine for now for me to play.
-mike
