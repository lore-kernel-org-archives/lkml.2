Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1D1FaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 01:30:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34587 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab1D1FaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 01:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=X7UwXUCJL+Sw+Ney/Ajz6nMY5LHh/ebM34UfpRgSWsrI65072/gycHb8iD4N/6QlJS
         R+iy4Ob6ni/zzHvk3ybL4ZQ8PySyDnKFJVHV37Z3jvef3zBDXLHVHsKWOByFSNAcFozu
         heOX1TD1nHWy/391JmPam6gwiX/9uQai2E/Ic=
MIME-Version: 1.0
In-Reply-To: <20110427175432.GA2328@joana>
References: <BANLkTi=UG0Xy2UEkNj2S_bS-PjOG5krNkQ@mail.gmail.com>
	<20110427175432.GA2328@joana>
Date: Thu, 28 Apr 2011 13:30:18 +0800
Message-ID: <BANLkTim=hU-D+174pFrksmA6Qimp9Xo1pA@mail.gmail.com>
Subject: Re: kernel panic after unplug usb bluetooth dongle
From: Dave Young <hidave.darkstar@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>,
        Bluettooth Linux <linux-bluetooth@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 1:54 AM, Gustavo F. Padovan
<padovan@profusion.mobi> wrote:
> * Dave Young <hidave.darkstar@gmail.com> [2011-04-27 14:35:59 +0800]:
>
>> Hi,
>>
>> Unplug usb bluetooth dongle make kernel panic as below. Thomas, any
>> idea about it?
>
> Commit b79f44c16a4 on
>
>        git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
>
> fixes this. The only problem is that it didn't arrive at mainline yet.

Confirmed, thank you.

>
> --
> Gustavo F. Padovan
> http://profusion.mobi
>



-- 
Regards
dave
