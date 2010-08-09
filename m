Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0HIAZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 20:25:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55585 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab0HIAZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 20:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OBTG494oKt/Nf/oNpP8lB4mAbgSVKGjOYqnfLQHWJNvf8Ss+vwUHPFRe+Qpkq1Ywvl
         iJd3MaxCcP3IHj235+22s6oBfSUsiMZ3Qs+OGGpqmEyNvrYfStxqwgAl9rnuBd+uRNXC
         p34I6ocOi7CSWoVofitI/dXfzgcMLt8gWuMFI=
MIME-Version: 1.0
In-Reply-To: <20100807.230156.25112206.davem@davemloft.net>
References: <20100804001429.6571.95116.stgit@localhost.localdomain>
	<20100804001615.6571.69837.stgit@localhost.localdomain>
	<20100807.230156.25112206.davem@davemloft.net>
Date: Sun, 8 Aug 2010 17:25:44 -0700
X-Google-Sender-Auth: R0Ak1QlGA8vuL7f_8ZwgxbzwvUk
Message-ID: <AANLkTinFNm0B37vtnqcFH_weq3zL9FZiRfE5QVk647PC@mail.gmail.com>
Subject: Re: [PATCH 2/2] igbvf.txt: Add igbvf Documentation
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, gospo@redhat.com,
        bphilips@novell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 7, 2010 at 23:01, David Miller <davem@davemloft.net> wrote:
> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Tue, 03 Aug 2010 17:16:17 -0700
>
>> Adds documentation for the igbvf (igb virtual function driver).
>>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
>
> Tons of trailing whitespace, GIT nearly craps itself when I try
> to apply this.
>
> Please fix this, and also submit the fixed up 1/1 ixgbe.txt doc patch
> and even more importantly the ixgbe FCOE build fix you promised I'd
> have two nights ago :-)
>
> Thanks.
> --

I will get you everything tonight, sorry about not getting the ixgbe
FCOE build fix when I said I would.  I was expecting better internet
connectivity than what I had the last couple of days.

-- 
Cheers,
Jeff
