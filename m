Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1CaAij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 20:38:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41785 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab1CaAih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 20:38:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HCcRJm4EoF3IoWsC+y29KJ/M6JU1v9Mq6sWX9a8RJDQEq05rH1pWBCLcG4xJSwsulK
         s6lvAb+2k9y1s49vI110g/ZcIGEpCkmg5wEEIMn9F6g6P8/TRH19fJyp5wECwDiFAin+
         BdDIYk6eBKSz8nd1Zcf+ZtbcxYSQEZMGbbODM=
MIME-Version: 1.0
In-Reply-To: <AANLkTinfm-rCRvah1wKGHpPGHrFV3ne90xChmUVCYup9@mail.gmail.com>
References: <1299990249-18264-1-git-send-email-bgat@billgatliff.com>
 <1299990249-18264-2-git-send-email-bgat@billgatliff.com> <AANLkTik1_Eekn7e0H+czCWHUX8LdioPH8MSHjcoZG6B=@mail.gmail.com>
 <AANLkTimEqRQS+yPpNuzF7XOk9cuDx2Mu1MKnfQkZDLfk@mail.gmail.com> <AANLkTinfm-rCRvah1wKGHpPGHrFV3ne90xChmUVCYup9@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 30 Mar 2011 20:38:16 -0400
Message-ID: <AANLkTik67VeN6rEFFzA7SU=FcTqWNgUX4bFxOstF3RTP@mail.gmail.com>
Subject: Re: [PWM v8 1/3] PWM: Implement a generic PWM framework
To: Bill Gatliff <bgat@billgatliff.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 20:36, Mike Frysinger wrote:
> On Wed, Mar 30, 2011 at 20:33, Bill Gatliff wrote:
>> On Wed, Mar 30, 2011 at 6:57 PM, Mike Frysinger wrote:
>>> On Sat, Mar 12, 2011 at 23:24, Bill Gatliff wrote:
>>>> +T:     git git://git.billgatliff.com/pwm.git
>>>
>>> $ git clone git://git.billgatliff.com/pwm.git
>>> Cloning into pwm...
>>> fatal: The remote end hung up unexpectedly
>>>
>>> :(
>>>
>>> why not get an account on kernel.org like everyone else and push your
>>> tree there ?
>>
>> Tried that once, got no response.
>>
>> I'm open to trying again if you can direct me to the right place.
>
> i used this:
> https://accounts.kernel.org/
>
> make sure to mention your PWM framework ?

in the mean time, you could easily use a free service like
http://repo.or.cz/ ...
-mike
