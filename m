Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2GRQYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:24:42 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:49445 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242Ab2GRQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:24:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120717020519.GA20277@kroah.com>
References: <1342108952-12987-1-git-send-email-eduardo.valentin@ti.com>
	<20120717020519.GA20277@kroah.com>
Date: Wed, 18 Jul 2012 19:24:37 +0300
Message-ID: <CAGF5oy-e=KvQi9FahNYK4D4Ad49RN4PP4FjvG2VD3bViZkJA-g@mail.gmail.com>
Subject: Re: [PATCHv4 0/4] staging: adding OMAP bandgap driver
From: "Valentin, Eduardo" <eduardo.valentin@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, b-cousson@ti.com, j-keerthy@ti.com,
        linux-kernel@vger.kernel.org, kbaidarov@dev.rtsoft.ru,
        grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Tue, Jul 17, 2012 at 5:05 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jul 12, 2012 at 07:02:28PM +0300, Eduardo Valentin wrote:
>> Greg,
>>
>> Here is again the OMAP BG driver, under staging area.
>> I fixed the compilation issue I didn't see, wrt implicit function
>> declarations. As I mentioned on other thread, my compilation test
>> didn't see it, that's why I thought it was fine to send it.
>>
>> I also limited the driver compilation to OMAP4/5.
>
> I edited the Makefile part of the patch by hand, and applied these
> patches, can you pull my tree and verify that I didn't break anything?

I checked the Makefile change, it is fine for me. Thanks for fixing it.

I also pulled your staging-next branch and verified that the code is
working fine. And it is OK.

>
> thanks,

Thanks to you for accepting it. We will be sending patches to you on
this driver from now on, in order to improve it's level of quality.

All best,

>
> greg k-h



-- 

Eduardo Valentin
