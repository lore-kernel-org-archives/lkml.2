Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997Ab1CWEBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 00:01:42 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:38709 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab1CWEBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 00:01:41 -0400
X-Greylist: delayed 1165 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Mar 2011 00:01:41 EDT
Date: Wed, 23 Mar 2011 04:42:14 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: linux-kernel@vger.kernel.org
Cc: Bernhard Kaindl <bk@suse.de>, Andi Kleen <andi@firstfloor.org>,
        linux-usb@vger.kernel.org
Subject: debugging a modern laptop ...
Message-ID: <20110323034214.GC15541@MAIL.13thfloor.at>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Bernhard Kaindl <bk@suse.de>, Andi Kleen <andi@firstfloor.org>,
	linux-usb@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greetings!

I'm trying to evaluate my options on debugging a recent
laptop/notebook/table (and the Linux kernel on it of course) 
from early bootup to diagnostics when the machine has locked
up ...

normally the first thing I would do is to attach a serial
console to monitor the early bootup and have some way to
send sysrq triggers ... but here is the first problem,
the thing might not even have a serial port at all ...

most modern devices have at least one usb port, but as far
as I could figure out via google, there is no support for
console or similar over usb (serial or not) atm
(please feel free to correct me here :)

after some research, I also found a quite antique project
exploiting the ieee1394 DMA feature, called firescope and
after some issues finding the latest version of the tool and
of course getting a firewire cable, there seems to be some
kind of interaction between the monitoring system and the
device in question, but it seems that a few problems exist
and I didn't manage to get any relevant information that
way yet (please let me know if that is still maintained)

finally, ethernet and netconsole, which seems to work
reasonably well, at least for the console logging part but
requires at least a supported 'wired' ethernet interface
and a few tricks to send commands to the device ...
(but only partially suited or early bootup of course)

have I missed something? 

what about bluetooth? (usually requires USB)
what about wireless? (probably quite problematic)

maybe a new kind of debug interface is needed in the 
near future?

any ideas and real world experiences are more than
welcome ...

many thanks in advance,
Herbert

