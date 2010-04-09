Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab0DIVzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:55:32 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61394 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab0DIVza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:55:30 -0400
MIME-Version: 1.0
In-Reply-To: <4BBF253A.8030406@redhat.com>
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
	 <4BAB7659.1040408@redhat.com> <201004090821.10435.james@albanarts.com>
	 <1270810226.3764.34.camel@palomino.walls.org>
	 <4BBF253A.8030406@redhat.com>
Date: Fri, 9 Apr 2010 17:55:28 -0400
Message-ID: <g2k829197381004091455m20368cc6r63df4a4f00d36b45@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@radix.net>, James Hogan <james@albanarts.com>,
       Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, kraxel@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 9, 2010 at 9:01 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> [1] Basically, a keycode (like KEY_POWER) could be used to wake up the machine. So, by
> associating some scancode to KEY_POWER via ir-core, the driver can program the hardware
> to wake up the machine with the corresponding scancode. I can't see a need for a change at
> ir-core to implement such behavior. Of course, some attributes at sysfs can be added
> to enable or disable this feature, and to control the associated logic, but we first
> need to implement the wakeup feature at the hardware driver, and then adding some logic
> at ir-core to add the non-hardware specific code there.

Really?  Have you actually seen any hardware where a particular scan
code can be used to wake up the hardware?  The only hardware I have
seen has the ability to unsuspend on arrival of IR traffic, but you
didn't have the granularity to dictate that it only wake up on
particular scancodes.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
