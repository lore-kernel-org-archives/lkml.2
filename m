Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450Ab2CGEou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 23:44:50 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:51729 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759030Ab2CGEot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 23:44:49 -0500
X-Greylist: delayed 1394 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2012 23:44:49 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20310.57932.964124.347872@quad.stoffel.home>
Date: Tue, 6 Mar 2012 23:21:32 -0500
From: "John Stoffel" <john@stoffel.org>
To: linux-kernel@vger.kernel.org
Subject: Why does NET_VENDOR_DEC default to y?
X-Mailer: VM 8.1.2 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just tried building a 3.3-rc6 kernel, based on my 3.1.0-rc4 kernel
config that I'm running.  Sue me, I don't upgrade my home server
quickly.

Anyway, I was watching the 'make oldconfig' zoom by and I noticed that
I was suddenly adding in DEC networking cards.  Now I admit I loved
the tulip cards from ages ago, but this is crazy.  I haven't had a DEC
card in my systems for years, and it's not like you find them in new
systems.  

So I poked into drivers/net/ethernet/dec/Kconfig and the stupid thing
is now setup so that NET_VENDOR_DEC defaults to Y.  Wtf?  Why do I
suddenly have to build in these drivers now?  Or even get asked about
them by default now?  

Maybe I'm just being too testy...

John
