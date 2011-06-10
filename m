Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1FJW7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:59:13 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59135 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab1FJW7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P0DX/AJ2ZJ5evtYwzvuyMKdx02ZNlzNuYOJc4UMVEUU+7c7hyDfnbHlVBHzjB/Ca3L
         ChLbznS1wT0roCoAXvnNb8LIh/ahnZ2Ob+63F0dFIWirORQErFGz0QXMuMjFq8wQ0LQ0
         +jl9rPWcFAIK64l3NSVcRXjFKQFmqxtEbD1is=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1106101552460.9183@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>
	<alpine.DEB.2.01.1106011712270.21697@trent.utfs.org>
	<1306983467.29297.51.camel@pasglop>
	<alpine.DEB.2.01.1106101552460.9183@trent.utfs.org>
Date: Sat, 11 Jun 2011 00:59:10 +0200
Message-ID: <BANLkTimbt6wz_Wye8atkDbkGqh+KOfm9cg@mail.gmail.com>
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linville@tuxdriver.com,
        LKML <linux-kernel@vger.kernel.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/11 Christian Kujau <lists@nerdbynature.de>:
> On Thu, 2 Jun 2011 at 12:57, Benjamin Herrenschmidt wrote:
>> John, care to send the patch below to Linus ASAP ? I could reproduce and
>> verify it fixes it. Thanks !
>>
>> ssb: pci: Don't call PCIe specific workarounds on PCI cores
>>
>> Otherwise it can/will crash....
>
> The patch did not make it into -rc2, it's not in today's git tree either,
> AFAICS. Can anyone push this, please?

Yeah, I noticed it wasn't in the pull for rc2. I pinged John, he told
me to just wait.

Patch was taken with the recent pull, it should go into rc3.

-- 
Rafał
