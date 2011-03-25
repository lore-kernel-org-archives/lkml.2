Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934411Ab1CYBlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 21:41:02 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63503 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab1CYBk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 21:40:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Tw4OyJRnQHP6Jf6wD07vraIF00g+uO/u6KLxXN0xnxZMDonzkP9j37MdH8GNVy9Akt
         U9GEFByM7aA8VovGfrAC2dI1fx8Tg6pGpgwPexGSLVGVxoPazgldm3TdR78/vxput8c6
         RXEGaNeaLnGseW74HVbQ7TykrWpD2u5j6diFw=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <641556B1566641C0A286D4F2F1383DAD@hacdom.okisemi.com>
References: <AANLkTik0tLsZCmcf8JNBtyePnKZzfoyA9SWH9k51+cc8@mail.gmail.com>
	<AANLkTi=gUTJs58mBkyLrvbtob=x=k6gD8-QR1HA61g+Q@mail.gmail.com>
	<641556B1566641C0A286D4F2F1383DAD@hacdom.okisemi.com>
Date: Fri, 25 Mar 2011 02:40:57 +0100
Message-ID: <AANLkTimhvxO=5GOenagc=F2hyzt-7yLSgDhQbWVuffsD@mail.gmail.com>
Subject: Re: linux-next: Tree for March 24 (BUG: soft lockup - CPU#0 stuck for
 63s! [kworker/0:1:7764])
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 1:08 AM, Tomoya MORINAGA
<tomoya-linux@dsn.okisemi.com> wrote:
> Hi  Sedat,
>
> We have used this DMA driver(include this patch) on linux-2.6.35/37.
> However I haven't seen the issue yet.
>
> I want to know more information.
> Do you mean that it takes 63 more seconds for boot-completing
> when using this patch and pch_dma is integrated as built-in ?
>
> Thanks,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.
>

I jumped back to the kernel from which I thought it was making
problems and run it several hours.
Unfortunately, I haven't seen any call-traces in the syslogs like before.
So, I could reproduce the errors.
I am sorry for the noise abd will have an eye on the issue.
( So, reverting the patch did not really helped. )

- Sedat -

>> -----Original Message-----
>> From: Sedat Dilek [mailto:sedat.dilek@googlemail.com]
>> Sent: Friday, March 25, 2011 12:10 AM
>> To: linux-next; LKML
>> Cc: Stephen Rothwell; Randy Dunlap; Vinod Koul; Tomoya MORINAGA
>> Subject: Re: linux-next: Tree for March 24 (BUG: soft lockup
>> - CPU#0 stuck for 63s! [kworker/0:1:7764])
>
>
