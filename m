Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1BDAPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 19:15:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57612 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1BDAPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 19:15:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=MRLoHEVOjGBZ5mnfujwCwTlEzn6OUzTOISG1p0kcxfTINi43Kcu+/EfzAss6dB6yuw
         elxrDQ16mqetSxwYvL2tfOVpOE7E3jmIEolpQ/dAZ/XWnuTet1N7trSdYhSFkJwoVsrz
         rb1Fj5EeZkcYgMpRm/AAlxftAsNGJwhQjBO84=
MIME-Version: 1.0
In-Reply-To: <20110203222006.GA12859@kroah.com>
References: <1294713837-4929-1-git-send-email-vapier@gentoo.org> <20110203222006.GA12859@kroah.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 3 Feb 2011 19:14:54 -0500
X-Google-Sender-Auth: hO9hlYnI_0NEuVAzwg-YfQKkTgs
Message-ID: <AANLkTikAsEMrZYz+yTpiTNv16B_0dtLHJBaXu3jvUPtW@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH] drivers: char: hvc: add Blackfin
 JTAG console support
To: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 17:20, Greg KH wrote:
> On Mon, Jan 10, 2011 at 09:43:57PM -0500, Mike Frysinger wrote:
>> This converts the existing bfin_jtag_comm TTY driver to the HVC layer so
>> that the common HVC code can worry about all of the TTY/polling crap and
>> leave the Blackfin code to worry about the Blackfin bits.
>
> This patch no longer applies to the linux-next tree.  Can you redo it
> and resend it?

guessing it's due to the tty reorg.  np.
-mike
