Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab0FUW65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:58:57 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58902 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0FUW6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=K9UEuzHgya+iXxQznte55BX/NC3IPflh1ei2+VKuWSlbWF3INCCadcEljSzJMORFtA
         fHY94EWGZfisiO5zCQe25l20LE1o3U6whlwjU6axeZHF6mHm2xURjuIO8uy5ds9X9SPx
         BrLWZXsx9607za14jP93ClCmhvYXBGhzf2xGA=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 21 Jun 2010 15:58:35 -0700
Message-ID: <AANLkTikmFJAHEBwAZ_lPosAZH3JO2zA5KetXuHvfe4WT@mail.gmail.com>
Subject: Linux script to enable ASPM / Documentation for ASPM
To: linux-kernel@vger.kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>, Martin Mares <mj@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASPM was a dark magic when I first started looking at it. Some of it
is still dark but what I was able to understand with the help of
colleagues at work I've managed to stash here for now:

http://wireless.kernel.org/en/users/Documentation/ASPM

Then enabling ASPM was also quite a challenge and I always had to go
back and revisit the procedures, so to help with that instead I wrote
a script to do this for you correctly:

http://kernel.org/pub/linux/kernel/people/mcgrof/aspm/enable-aspm

Its sha1sum is: f5804fdab512065f219e55addf78c6654f1fc045

If any of that looks confusing refer to the documentation above.

There's a TODO there, so I'll get to the different items when I can
but if you like feel free to send me patches as well:

 TODO: patches are welcomed to me until we submit to to
       PCI Utilities upstream.

 This can be improved by in this order:

        * Accept arguments for endpoint and root complex address, and
          desired ASPM settings
        * Look for your ASPM capabilities by quering your
          LnkCap register first. Use these values to let you
          select whether you want to enable only L1 or L1 & L0s
        * Searching for your root complex for you
        * Search for your PCI device by using the driver
        * Disable your driver and ask to reboot ?
        * Rewrite in C
        * Write ncurses interface [ wishlist ]
        * Write GTK/QT interface [ wishlist ]
        * Submit upstream as aspm.c to the PCI Utilities, which are
          maintained by Martin Mares <mj@ucw.cz>

  Luis
