Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2KGODy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:03:54 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40206 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2KGODw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:03:52 -0500
Message-ID: <509A6A44.5070006@suse.cz>
Date: Wed, 07 Nov 2012 15:03:48 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jhovold@gmail.com
Subject: mos7840 build warning [was: Linux 3.0.50]
References: <20121031173459.GA12769@kroah.com>
In-Reply-To: <20121031173459.GA12769@kroah.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 06:34 PM, Greg KH wrote:
> Johan Hovold (9): USB: mos7840: remove invalid disconnect handling

This one introduces a warning:
drivers/usb/serial/mos7840.c: In function 'mos7840_disconnect':
drivers/usb/serial/mos7840.c:2589: warning: unused variable 'flags'

Care to fix that?

thanks,
-- 
js
suse labs
