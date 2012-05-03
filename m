Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2ECJjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:39:09 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:39273 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab2ECJjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:39:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4FAIlRok9bdWOb/2dsb2JhbABFgx6wB4EHggkBAQV4ARALGAkWDwkDAgECAUUGDQEFAgEBiA26dJEIBJV+hXaKTIJq
X-IronPort-AV: E=Sophos;i="4.75,523,1330902000"; 
   d="scan'208";a="901241889"
Message-ID: <4FA25238.8090902@igalia.com>
Date: Thu, 03 May 2012 11:39:04 +0200
From: =?ISO-8859-1?Q?Samuel_Iglesias_Gons=E1lvez?= <siglesias@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: ipack: add support for IP-OCTAL mezzanine
 board
References: <1336031267-10689-1-git-send-email-siglesias@igalia.com> <1336031267-10689-4-git-send-email-siglesias@igalia.com> <20120503101513.2b2915ef@pyramind.ukuu.org.uk>
In-Reply-To: <20120503101513.2b2915ef@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 11:15 AM, Alan Cox wrote:
> On Thu,  3 May 2012 09:47:47 +0200
> Samuel Iglesias Gonsalvez <siglesias@igalia.com> wrote:
>
>> IP-OCTAL is a 8-channels serial port device. There are several models
one per
>> each standard: RS-232, RS-422, RS-485.
>>
>> This driver can manage all of them.
>
> What are the plans for cleaning up this set of patches ?
>

Fix the wrong stuff in the needed iterations before they reach staging.
I can work on it the following weeks.

Looking at your comments, at least this patch needs more love before
being accepted in staging. I will work on it and send them again
including the suggestions of the other patches.

[...]
>
> Can't really comment on the bus stuff, but the tty driver looks mostly
> ok. It just needs a bit of modernising, and apart from that, and the
> locking issue on write looks pretty good.

Thanks,

Sam
