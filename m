Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab0GNFBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 01:01:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62496 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0GNFBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 01:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FKTSBlVcrBjq+e8zl+Ora9NXTsDenu7CTR64jtkEFShTGy/zyqXatD78gE4V48zNLH
         Mm5FT1nFDomJsNjbSCp80/ik9tkmDCGLb4UonZlMjKxC/eWnoFIrr+5IYvVodcxYMeX3
         QOWG4KF9woNWhiW3V0Y4yyujIMvHeNlWcb0Mk=
MIME-Version: 1.0
In-Reply-To: <201006091343.48924.toralf.foerster@gmx.de>
References: <201006071122.21925.toralf.foerster@gmx.de>
	<20100607141103.GA9477@srcf.ucam.org>
	<201006091343.48924.toralf.foerster@gmx.de>
Date: Wed, 14 Jul 2010 06:01:28 +0100
Message-ID: <AANLkTimkWN5tU88J-M3Q4aq9pq-WljyyPAUPfnf9cuhf@mail.gmail.com>
Subject: Re: ThinkPad T400 : should kernel option "reboot=pci" be hard coded ?
From: Pedro Ribeiro <pedrib@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/9 Toralf Förster <toralf.foerster@gmx.de>:
> Hi,
>
> Matthew Garrett wrote at 16:11:03
>> On Mon, Jun 07, 2010 at 11:22:21AM +0200, Toralf Förster wrote:
>> > Since some kernel version (IIRC since 2.6.31) it is necessary to boot the
>> > linux kernel with that option to prevent an extra 9 seconds delay during
>> > reboot.
>> > I found this tip on the LKML -and now I'm wondering whether this option
>> > should be hard coded in the kernel sources b/c it seems to be necessary
>> > for current kernels too.
>>
>> No, the best thing to do would be to figure out what changed to require
>> the extra 9 seconds. Are you able to work out which the last kernel
>> release without this timeout was?
> The delay exists since 2.6.27, versions before them I can't test due to
> udev-149 which don't work together with version < 2.6.27.
>
> Since version 2.6.29 that kernel boot parameter avoids the extra delay, 2.6.28
> needs the 9 sec pause independend from what I specify during boot.
>
> --
> MfG/Kind regards
> Toralf Förster
>
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I also have a T400, and reboot=pci solves the problem for me.

Just tested with kernel 2.6.20 and the 9 second boot delay is still
there. Maybe this should be hardcoded...

Regards,
Pedro
