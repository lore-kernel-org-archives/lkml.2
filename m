Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0LMLkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 06:40:20 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53778 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab0LMLkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=vo2oU+77O5lT9mmaeLOGx772xMfY6YrEx+lrrHMWenzzSMLhsY+u5r6M37eJ6amXGm
         gegAqTDsbz11QnSE+xuz6HtATgg3srdO0swK8xaBgUSwMh6cHqm3mx15Lh81W8MGG9Zs
         pFxsZUAQFxwxYjyS+09nv1CUj7EmFwQD+w+N8=
MIME-Version: 1.0
Date: Mon, 13 Dec 2010 12:40:17 +0100
Message-ID: <AANLkTin2Z5XXf-3Gkqj72+FT4rM+hpqehK8Ys=gg++c9@mail.gmail.com>
Subject: Re: [RFC] persistent store (version 3) (part 1 of 2)
From: Marco Stornelli <marco.stornelli@gmail.com>
To: tony.luck@intel.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

could you cc linux fs devel and maybe linux embedded mailing list?
Currently I try to insert in mainline the pramfs. Maybe we have the
same goal and we could "merge" our effort. What do you think? Sure the
kernel from this point of view has got a lack of support, I see
different approach and solution to this. I saw in the staging tree a
pmem driver of google guys that it seems to be designed for the same
goal.

Marco

>Generic code for a "persistent store" file system as an interface
>to provide a friendly user level ABI to platform specific drivers
>for that access to some form of non-volatile storage that can be
>used to save the dying words of an OS instance and make them
>available after the reset/reboot.
>
>Signed-off-by: Tony Luck <tony.luck@intel.com>
