Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1AYJTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 04:19:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42613 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab1AYJTQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 04:19:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I4SofETfhl8TdGkuO+pCYH/TNldS4FwUK6UpufN0fEUvyEBiM2WGrB0oby+bchxu3D
         wVhKsX76MtfKC6GIvlL9sfmQg9V+AmARGihk/0I4SJpB7zFUgoUGh2zT7X+c58+bHmp0
         MduLmTRDC6GehjCS1O0P0fwpy4EDmrihCKGj4=
MIME-Version: 1.0
In-Reply-To: <8yad3nlh18e.fsf@huya.qualcomm.com>
References: <AANLkTi=eCOiP7MrUSG4WRMN0kj_+ZWvZ=z7VYDfkshU_@mail.gmail.com>
	<8yad3nlh18e.fsf@huya.qualcomm.com>
Date: Tue, 25 Jan 2011 17:19:16 +0800
Message-ID: <AANLkTin9fSw5DdqdgCEvtdtc83LFOeA7t0OAUugVmRFD@mail.gmail.com>
Subject: Re: questions about arm trustzone
From: sen wang <wangchendu@gmail.com>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks,
It seems linux run in the normal world, and the "scm.c"  is the path
to the monitor mode.
where can I find the example code for monitor and secure world?



2011/1/25 David Brown <davidb@codeaurora.org>:
> On Mon, Jan 24 2011, sen wang wrote:
>
>> we need to build a little os in the secure mode,and run linux in the
>> normal world.but, can I use gcc to compile the special instructions like 'smc'.
>> which gcc version can work? and where can i find the example code
>> switching between the secure and normal worlds?
>
> In the 2.6.38-rc2 kernel, arch/arm/mach-msm/scm.c does this.  I don't
> think there is any other code in the kernel, yet.
>
> David
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
