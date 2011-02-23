Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1BWL6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 06:58:54 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:42701 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1BWL6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 06:58:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=uPeBMkO4gm9M69AKPsY58oPAseBEXQ0r61pRs443r+mgpQNyIVzt3IfEwaocb4ZCR0
         ceXnvOjAF156/OwLzrYoAV2YE96+QQH1v2qL7yfMqLTt3hiuhvqAYDZaEjyn59X2zdnP
         kJF8IbiM6D8XKwPU5twYI2uob1BtoEwikEJpg=
Message-ID: <4D64F678.10309@gmail.com>
Date: Wed, 23 Feb 2011 12:58:48 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@suse.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
References: <Pine.LNX.4.44L0.1102221029100.1968-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102221029100.1968-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 04:36 PM, Alan Stern wrote:
> By the way, are you booting with no_console_suspend?  And do you do 
> "echo 8 >/proc/sys/kernel/printk" (or equivalently, Alt-SysRq-8) before 
> suspending?

Nope.

> What about if you leave async enabled for all the USB devices _except_ 
> usb[1-N]?

Ok, so now I have:
/sys/bus/usb/devices/usb1/power/async:disabled
/sys/bus/usb/devices/usb2/power/async:disabled
/sys/bus/usb/devices/usb3/power/async:disabled
/sys/bus/usb/devices/usb4/power/async:disabled
/sys/bus/usb/devices/usb5/power/async:disabled
/sys/bus/usb/devices/usb6/power/async:disabled
/sys/bus/usb/devices/usb7/power/async:disabled
/sys/bus/usb/devices/usb8/power/async:disabled
/sys/bus/usb/devices/1-0:1.0/power/async:enabled
/sys/bus/usb/devices/2-0:1.0/power/async:enabled
/sys/bus/usb/devices/2-6/power/async:enabled
/sys/bus/usb/devices/2-6:1.0/power/async:enabled
/sys/bus/usb/devices/2-6:1.1/power/async:enabled
/sys/bus/usb/devices/3-0:1.0/power/async:enabled
/sys/bus/usb/devices/4-0:1.0/power/async:enabled
/sys/bus/usb/devices/4-2/power/async:enabled
/sys/bus/usb/devices/4-2.1/power/async:enabled
/sys/bus/usb/devices/4-2:1.0/power/async:enabled
/sys/bus/usb/devices/4-2.1:1.0/power/async:enabled
/sys/bus/usb/devices/4-2.1:1.1/power/async:enabled
/sys/bus/usb/devices/4-2.2/power/async:enabled
/sys/bus/usb/devices/4-2.2:1.0/power/async:enabled
/sys/bus/usb/devices/5-0:1.0/power/async:enabled
/sys/bus/usb/devices/6-0:1.0/power/async:enabled
/sys/bus/usb/devices/7-0:1.0/power/async:enabled
/sys/bus/usb/devices/8-0:1.0/power/async:enabled

Let's see.

regards,
-- 
js
