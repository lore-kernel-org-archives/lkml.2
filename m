Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab0EGDAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 23:00:04 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:64166 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab0EGDAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 23:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bIRYjXc9yuGoyptQfEx/RaXl5rmLPtcrVgWEBQSd/KDKfCcTT0wuhqqalHfzJ41NQO
         4ZLxyC+diWzvFY3cAT+YzvK5MgCSothgFn8lzZc4qQ9OKTaX2vYWSoddQSBAwATOKhNo
         BUjuGfnw1D2IQpPKnCOcdQHVGkwU4cDRgZ6ls=
Message-ID: <4BE38239.1010901@gmail.com>
Date: Thu, 06 May 2010 20:00:09 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Lex Hider <floss@lex.hider.name>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression: monitor fails to sleep/suspend, forced to reboot
 to 	correct. 2.6.34-rc6
References: <AANLkTingM7EsCtbElXTNzzjZt4kG5acQtbt5mJEIVbrW@mail.gmail.com>
In-Reply-To: <AANLkTingM7EsCtbElXTNzzjZt4kG5acQtbt5mJEIVbrW@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 07:30 PM, Lex Hider wrote:
> Hi,
>
> My current setup has worked on previous kernels, I think the problem
> has begun with 2.6.32.
>
> If the monitor goes to standby/suspend it shows:
>
> "Out of Range
>
> H.frequency 33 KHz
> V.frequency 31 Hz"
>
> I can test this with running: "xset dpms force standby" or "xset dpms
> force suspend".
>
> I can no longer switch to console with Ctrl+Alt+F2, etc, and must
> reboot to be able to use my system again.
>
> Please advise what additional information/testing I can provide to
> make sure this regression gets fixed for 2.6.34.
>
> This bug appears to affect all recent distros as they are 2.6.32 based
> (ubuntu lts, debian, rhel6).
>
> I have reported the following bugs with little response. I am unsure
> whether I have filed bugs in the correct place or against the correct
> component.
>
> http://bugs.freedesktop.org/show_bug.cgi?id=26423
> https://bugzilla.redhat.com/show_bug.cgi?id=581898
>
> Please CC me in on any replies.
>
> Thanks,
>
> Lex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Can you do a bisect?
(2.6.32 - HEAD shouldn't
take too long).

Justin P. Mattock
