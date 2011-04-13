Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab1DMWBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:01:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46661 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab1DMWBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JsPxqH2Aj3aR0eyXN8N/U2jIwISkW72z7Z4cynNeIBgqRSQtTVChjMInV8qhmKT/Vf
         hbYuRJtX8EBcDxN0ocZIpMmWigoYKWhRmkwrWG7Ex94wbq1Y31VCO5/QAHZhyclPZSou
         17988uNQRZP3MOR3siUpjh/9WAisOKWRe9Zl4=
MIME-Version: 1.0
In-Reply-To: <20110413131054.8771d855.rdunlap@xenotime.net>
References: <BANLkTikAqz5xBRfpxBuwxVujE--Qam2FsQ@mail.gmail.com>
	<20110413131054.8771d855.rdunlap@xenotime.net>
Date: Wed, 13 Apr 2011 17:01:38 -0500
Message-ID: <BANLkTi=KvxPNuvZnL90SAmkQna=ARE6xyQ@mail.gmail.com>
Subject: Re: Disable PCI while CONFIG_PCI=y
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes I read that but my ARCH is arm.

Thanks,

On Wed, Apr 13, 2011 at 3:10 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 13 Apr 2011 15:05:59 -0500 Xianghua Xiao wrote:
>
>> Is it possible to do something like 'pci=off' to have the same effect
>> as turning of CONFIG_PCI during menuconfig?
>> I want to build one image for both PCIE RC and PCIE EP(endpoint), for
>> EP I do not need PCI to be enabled at all.
>>
>> looking at drivers/pci/pci.c I don't see such option exists, am I
>> missing something?
>
> Hm. Documentation/kernel-parameters.txt says:
>
>
>        pci=option[,option...]  [PCI] various PCI subsystem options:
>                earlydump       [X86] dump PCI config space before the kernel
>                                changes anything
>                off             [X86] don't probe for the PCI bus
>
> What $ARCH are you using?
>
> See arch/x86/pci/common.c::pcibios_setup() for code that handles
>        pci=off
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
