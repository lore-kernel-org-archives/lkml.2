Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab2ADUen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 15:34:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50628 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2ADUek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 15:34:40 -0500
Message-ID: <4F04B7DC.70809@suse.cz>
Date: Wed, 04 Jan 2012 21:34:36 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111130 Thunderbird/9.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: alan@linux.intel.com, gregkh@suse.de, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] serial: relocate remaining serial drivers from tty/ to
 tty/serial/
References: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 09:01 PM, Paul Gortmaker wrote:
>  rename drivers/tty/{ => serial}/amiserial.c (100%)
>  rename drivers/tty/{ => serial}/cyclades.c (100%)
>  rename drivers/tty/{ => serial}/isicom.c (100%)
>  rename drivers/tty/{ => serial}/moxa.c (100%)
>  rename drivers/tty/{ => serial}/moxa.h (100%)
>  rename drivers/tty/{ => serial}/mxser.c (100%)
>  rename drivers/tty/{ => serial}/mxser.h (100%)
>  rename drivers/tty/{ => serial}/rocket.c (100%)
>  rename drivers/tty/{ => serial}/rocket.h (100%)
>  rename drivers/tty/{ => serial}/rocket_int.h (100%)
>  rename drivers/tty/{ => serial}/synclink.c (100%)
>  rename drivers/tty/{ => serial}/synclink_gt.c (100%)
>  rename drivers/tty/{ => serial}/synclinkmp.c (100%)

Hmm, tty/serial/* used to be for those using serial-core. And tty/ for
those who don't. But FWIW I don't mind the change.

-- 
js
suse labs
