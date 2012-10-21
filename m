Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2JULWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 07:22:55 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47200 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab2JULWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 07:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <20121021104217.GE14031@elf.ucw.cz>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
	<20121021104217.GE14031@elf.ucw.cz>
Date: Sun, 21 Oct 2012 16:52:52 +0530
Message-ID: <CANBXnMnqPMR7fQ0MwaK71K5rAVN56U6_oR2=cr4ss6kOxtgtsg@mail.gmail.com>
Subject: Re: [PATCH 0/9] Staging: winbond: Fixed coding style issues
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Sun, Oct 21, 2012 at 4:12 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Fri 2012-10-12 22:07:06, Adil Mujeeb wrote:
>>
>> winbond directory files have lots of coding style issues. The patch
> set tries to remove *most* (if not all) of the coding style
> issues. checkpatch.pl script is still complaining (like 80 characters
> limit) but major part of the serious coding style issues have been
> rectified.
>
> ACK on patches except 2 and 5. Plus if you could keep the printks,
> that would be great. When the driver is debugged and in wide use, we
> can remove them, but now they are useful...

Thanks Pavel for acknowledgement.

I removed printk's as Joe and Greg recommended to remove "tracing"
type debug calls. Let me know if I need to resubmit the patch.

Regards,
Adil

>
> Thanks,
>                                                                         Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
