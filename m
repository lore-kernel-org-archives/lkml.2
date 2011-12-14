Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1LNKd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:33:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39995 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab1LNKdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:33:25 -0500
MIME-Version: 1.0
In-Reply-To: <201112140901.35203.oneukum@suse.de>
References: <1321529030-7845-1-git-send-email-djkurtz@chromium.org>
 <1321529030-7845-4-git-send-email-djkurtz@chromium.org> <201112140901.35203.oneukum@suse.de>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 14 Dec 2011 18:33:03 +0800
X-Google-Sender-Auth: vQvWCq-q3twQ9VpMh5BDrispx54
Message-ID: <CAGS+omA=9qfqDYtaLp67Xz+WhcpW_=jn9hoiaad43Z+oexjsFQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] HID: usbhid: defer LED setting to a workqueue
To: Oliver Neukum <oneukum@suse.de>
Cc: jkosina@suse.cz, bleung@chromium.org, stern@rowland.harvard.edu,
        olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 4:01 PM, Oliver Neukum <oneukum@suse.de> wrote:
> Am Donnerstag, 17. November 2011, 12:23:50 schrieb Daniel Kurtz:
>> Defer LED setting action to a workqueue.
>> This is more likely to send all LED change events in a single URB.
>
> Hi,
>
> I hope I am looking at the correct version of this patch.
> But as far as I can see the work for handling LEDs is not delayed
> while a reset is going on. That is wrong.

Actually, I'm not sure why this is wrong.  I find the reset handling
quite confusing in this driver.
Can you point out what will fail, and recommend how to fix it?

Thanks & Best Regards
-Daniel

>
>        Regards
>                Oliver
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
