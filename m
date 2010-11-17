Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624Ab0KQEUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:20:04 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53215 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab0KQEUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:20:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=FIrHu5/jOzv8EuYYnWmKflqzqWV7bTyOUSh9gCBGk/x26+wlAt9CGHRiL40tdeDWQ4
         zeaGBN6khJueqhRL/+Icex0Ksxlurii+okYlQVdzMipF6Sa57orArSlNuzd5jCABxihK
         mUjATFxmmG61Xf9CVtBVVdbbrXCe9D83BYlow=
MIME-Version: 1.0
In-Reply-To: <20101116131719.34193c59.randy.dunlap@oracle.com>
References: <AANLkTinLKibXfnN2XSVE2P_x3EJancRNdi3B4YBxvL=j@mail.gmail.com>
	<20101116131719.34193c59.randy.dunlap@oracle.com>
Date: Wed, 17 Nov 2010 06:20:01 +0200
Message-ID: <AANLkTikXnGfB-8ju+goEUPuoztb1FL=0mPRpxjQgZ18B@mail.gmail.com>
Subject: Re: Build failure 2.6.37-rc2
From: Anca Emanuel <anca.emanuel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:17 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Tue, 16 Nov 2010 09:30:53 +0200 Anca Emanuel wrote:
>
>>   Building modules, stage 2.
>>   MODPOST 2794 modules
>> FATAL: arch/x86/kernel/msr.o has no symtab?
>> make[2]: *** [__modpost] Error 1
>> make[1]: *** [modules] Error 2
>> make[1]: Leaving directory `/home/emi/linux-2.6'
>> make: *** [debian/stamp/build/kernel] Error 2
>> --
>
> Tools problem?  I can't reproduce it.
>
> Maybe post your .config file and tell us what gcc and ld versions
> you are using...
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

uname -a
Linux ubuntu 2.6.37-rc2+ #2 SMP Wed Nov 17 04:27:44 EET 2010 i686 GNU/Linux

2.6.37-rc2-git1 running ok here.
