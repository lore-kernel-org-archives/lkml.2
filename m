Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab1AJSAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:00:05 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36024 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab1AJSAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:00:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=I7T066sd07S3M1i332elB+l7AYeXSAgYJI4GqwqwwK/fCmyAMdfONMMjLEgf+fOEKy
         r97RfpMb1reVlBX4ejxEquc9fOT4p0gAeHRaW2Wt6Z+PAwMi40BcqI5ewiqWfgiz1EUs
         6S0xtzH+e3HtauQeYivYdE27+KVPXaJSibocc=
MIME-Version: 1.0
Date: Mon, 10 Jan 2011 19:00:00 +0100
X-Google-Sender-Auth: H5_8nDItecwb7bXMv3YLERiWkgk
Message-ID: <AANLkTimHzjRLxGLabXgh7bvoD+f9jOC8CRS0YFeKzMDz@mail.gmail.com>
Subject: [GIT PULL] ux500-core leftovers
From: Linus Walleij <linus.walleij@stericsson.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rabin VINCENT <rabin.vincent@stericsson.com>,
        linux-arm-kernel@lists.infradead.org,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, could you please pull:

      git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git
for-torvalds

This is based on commit 0c21e3a and contains
the following patches that couldn't be merged through
Russell's ARM tree due to cross-branch dependencies
now sorted out in your tree:

Rabin Vincent (5):
      ux500: remove build-time changing macros
      ux500: rename MOP board Kconfig
      ux500: dynamic SOC detection
      ux500: modem_irq is only for 5500
      ux500: allow 5500 and 8500 to be built together

Yours,
Linus Walleij
