Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0ICG2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 02:28:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64645 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0ICG2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 02:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xh/zG4SXW+Dy6580frxK5xWikguLxRZwTN3qJ5zGLcnUIAukN0FK0YQjBPEeaF9sqm
         Iaf6ZCpu4zG/cXM9uSv06AoL6CVYsjV7tkXe2e3Lun488/Wr2cecZuMym7FEweaLaHL0
         MwCGVm3vac+OrQ9b+W8pepdo/cUY6/3AyJpBc=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1009021022270.1513-100000@iolanthe.rowland.org>
References: <AANLkTi=ZzbTb+uQchDDYfNibDv=LafQYuvRe2TVFpFGO@mail.gmail.com>
	<Pine.LNX.4.44L0.1009021022270.1513-100000@iolanthe.rowland.org>
Date: Fri, 3 Sep 2010 11:58:42 +0530
Message-ID: <AANLkTin5U3xY2ZFSZ9RsK7mADy0L8XiGWrsFHhQ=-WEx@mail.gmail.com>
Subject: Re: Resetting USB HC .. During kernel boot
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        listar@nl.linux.org, kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

  I am working on a board, where USB controller is on chip. and this
has both UHC and EHC.  I have to reset these during the boot up.
Bootloader does not reset it before handing over control to kernel, I
am facing crash. So I am planning to reset here in kernel.

Can you help to locate the file, where this part of the code can be inserted.

Thanks in advance,
Prabhu


On Thu, Sep 2, 2010 at 7:56 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 2 Sep 2010, Prabhu Chawandi wrote:
>
>> Hi All,
>>
>>    I want to reset the USB HC  while the booting is happening. I have
>> the register details and functionality with me, but not sure which
>> part of the code to insert this segment.
>>
>> please advice me ...
>
> Why do you want to do this?
>
> Anyway, it depends on what type of host controller you're talking
> about.  UHCI controllers are already reset during boot.  The same is
> true for PCI-based EHCI and OHCI controllers (except on certain PA-RISC
> systems).
>
> I haven't checked the various non-PCI controllers.
>
> Alan Stern
>
>
