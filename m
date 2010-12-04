Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0LDLDx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 06:03:53 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56439 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab0LDLDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 06:03:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uhZjH8pPoyi56zXXYcVGWaxfbJH/ZZjKPPr5N+lBtI9IZhEVTQdTkqxU6MPYK1x2T7
         BdiztVS+/f0FgnFRbDjBv6N6+mfjYlsqrwXVQe62n21lQIICpPMNhkNXx4H4wtK/gF3x
         ziP6wuyYGliSOaoVdvOyaNljJO2EoQRcPspj0=
MIME-Version: 1.0
In-Reply-To: <a33a0b00eeb29713a08d91156cbb2d816176f990.1291419007.git.joe@perches.com>
References: <cover.1291419007.git.joe@perches.com>
	<a33a0b00eeb29713a08d91156cbb2d816176f990.1291419007.git.joe@perches.com>
Date: Sat, 4 Dec 2010 12:03:50 +0100
Message-ID: <AANLkTi=qh0GKp3BdKO9GX1qmM3iJ6J_F3fLqZ8qNAw5v@mail.gmail.com>
Subject: Re: [PATCH 1/2] vsprintf: Add %pMbt, bluetooth mac address
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/4 Joe Perches <joe@perches.com>:
> Bluetooth output the MAC address in reverse order.
> Bluetooth memory order: 00 01 02 03 04 05 is output "05:04:03:02:01:00".
>
> This can save overall text when bluetooth is compiled in.
>
> Bluetooth currently uses a very slightly unsafe local function (batostr)
> to output these formatted addresses.
>
> Adding %pMbt allows the batostr function to be removed.

Just a nitpick:
You could call it %pMR, as in 'Reverse', so it sounds better when/if
some other subsystem uses it. It would also be a hint of what is this
doing instead of where it came from.

Best Regards,
Micha³ Miros³aw
