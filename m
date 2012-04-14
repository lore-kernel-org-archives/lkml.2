Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab2DNKqE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:46:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45306 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2DNKqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:46:02 -0400
MIME-Version: 1.0
In-Reply-To: <CADDKRnALwHa=QteDDcMxBU24rfbKoTOGX=iTcfeE7=M7a+NFcw@mail.gmail.com>
References: <CADDKRnALwHa=QteDDcMxBU24rfbKoTOGX=iTcfeE7=M7a+NFcw@mail.gmail.com>
Date: Sat, 14 Apr 2012 12:46:01 +0200
Message-ID: <CADDKRnAhqi-fwFrr85QC-ZP2g0=_ZSb__jEbZqAekCKXs2CtCg@mail.gmail.com>
Subject: Re: [v3.4-rc] regression: reboot not working
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's now bisected:

cf450136bfde77c7f95065c91bffded4aa7fa731   ACPI: ignore FADT reset-reg-sup flag

Thanks, Joerg


Am 9. April 2012 17:19 schrieb Jörg Otte <jrg.otte@googlemail.com>:
> Hi,
>
> On reboot it shuts down as normal.
> The last lines displayed are:
>
>>.
>>Unmounting temporary filesystems.. [OK]
>>Deactivating swap...               [OK]
>>Unmounting local filesystems...    [OK]
>>Will now restart
>>    Restarting system
>
> Then I hear it accessing the cd-drive, but then
> it's being stuck.
>
> v3.3 was ok. HW is a Thinkpad T43.
>
> Please Cc me I'm not subscribed.
>
> Thanks,Joerg
