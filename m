Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab0GMRRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:17:31 -0400
Received: from www17.your-server.de ([213.133.104.17]:46674 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab0GMRR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:17:29 -0400
References: <1279037435.9846.17.camel@localhost> <AANLkTil6WK0m6DowcjVGRSk-EMPZlW98AhgPHwlFkB0v@mail.gmail.com>
In-Reply-To: <AANLkTil6WK0m6DowcjVGRSk-EMPZlW98AhgPHwlFkB0v@mail.gmail.com>
Mime-Version: 1.0 (iPod Mail 8A293)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <A814D4DC-504F-44FC-A442-24599761D981@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: iPod Mail (8A293)
From: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.35-rc5 seems hangs at "[drm] Loading REDWOOD Microcode"
Date: Tue, 13 Jul 2010 19:17:43 +0200
To: Alex Deucher <alexdeucher@gmail.com>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 13.07.2010 um 18:37 schrieb Alex Deucher <alexdeucher@gmail.com>:

> On Tue, Jul 13, 2010 at 12:10 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>> Hi.
>> 
>> I gave 2.6.35 a try and the last message I see before the boot process
>> seems to hang is something like:
>> "[drm] Loading REDWOOD Microcode"
>> 
>> 
> 
> The microcode needs to be included in your initrd otherwise the driver
> can't find it when it loads.
> 

Oppsie! Dracut does only include firmware for modules, but I did link-in the driver into the kernel. Sorry. Cryptsetup in the initrd still fails to open /dev/sda4. 

Thomas