Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab2HTScr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:32:47 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:49371 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2HTScp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:32:45 -0400
Date: Mon, 20 Aug 2012 20:31:58 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "werner" <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.6-rc2 crashs often with keyboard blinking
Message-ID: <20120820203158.245d6b06@neptune.home>
In-Reply-To: <web-782181085@zbackend1.aha.ru>
References: <web-782181085@zbackend1.aha.ru>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 August 2012 "werner" <w.landgraf@ru.ru> wrote:
> 3.6-rc2 crashs often (not during the boot, but later when 
> using KDE and internet)
> Then the keyboard is blinking, sometimes 2, sometimes 3 
> lamps (Caps Lock, Scroll lock, sometimes Num Lock too)
> With 3.6-rc2 this didn't happen.   The configuration stays 

Huh, above you just said 3.6-rc2 crashes...

> the same.
> In the logfiles is nothing visible.
> Ideas how to catch this ?

If you can hook a serial cable to your system and boot it with
console=/dev/ttyS0 console=tty0 (assuming you hook ttyS0, and adding
baud-rate as needed) you can grab possible kernel out this way.

Alternatively you can also use netconsole and capture output on
a second system on your network (e.g. with netcat).

See Documentation/kernel-parameters.txt and Kconfig help for
netconsole for details.

Bruno
