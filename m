Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab0JRPA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:00:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60165 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab0JRPA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:00:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RViXUb1y917jDktDVcN2Po0hfAuXdzGMOAZ2ZEl1uU5u2upJAGm3GCghyqpePN6qJl
         9FhI6qBZmwQnd+BBmDQRcbkpFqLUksV4I73IW9JLxk/5cs33gKxkbOzq/Jw1vzzyfDgn
         CGDD99k4MSmptO0Ari+4sHDMj0WEwOUBzdqVw=
MIME-Version: 1.0
In-Reply-To: <20101018145620.GA22538@pengutronix.de>
References: <1287454010-2718-1-git-send-email-zhangyd6@gmail.com>
	<20101018145620.GA22538@pengutronix.de>
Date: Mon, 18 Oct 2010 23:00:25 +0800
Message-ID: <AANLkTink3zhFQSswA0XFvuZu=AUDmGxMWWbqWsF=qyB+@mail.gmail.com>
Subject: Re: [PATCH] mtd: chips: Add SST38VF640x NOR-flashes
From: yidong zhang <zhangyd6@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: dwmw2@infradead.org, Artem.Bityutskiy@nokia.com, ladis@linux-mips.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 10:56 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Mon, Oct 18, 2010 at 10:06:50PM -0400, zhangyd wrote:
>> Du to the wrong sector size description(The actual sector size is
>> 8KBytes/sector, but the reporting size is 64KBytes/sector),you can get
>> the wrong size of the memory. So they should be moved to the jedec_probe.
>>
>> Signed-off-by: yidong zhang<zhangyd6@gmail.com>
>
> NACK as long as Guillaume has not finished updating the SST-support for CFI. He
> said he is working on this at the moment, let's give him a chance to finish :)

OK , Thanks!

> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
>
> iEYEARECAAYFAky8YBQACgkQD27XaX1/VRtz6ACeMLJleCWrFki71rpj+0ELYala
> A8sAnA6Frg62shANhZn7xEW1196rHBxr
> =P1xd
> -----END PGP SIGNATURE-----
>
>
