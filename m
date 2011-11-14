Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1KNWmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 17:42:18 -0500
Received: from mail2.unitix.de ([176.9.2.175]:49197 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523Ab1KNWmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 17:42:17 -0500
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Nov 2011 17:42:17 EST
Message-ID: <4EC19738.8050007@arndnet.de>
Date: Mon, 14 Nov 2011 23:33:28 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.2rc1: bootup fails: DRHD: handling fault status reg 2
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when trying to boot kernel 3.2rc1 on my thinkpad t510 I get an endless loop of errors:

 DRHD: handling fault status reg 2
 DMAR: [DMA Read] Request device [0d:00.0] fault addr fffff000
 DMAR: [fault reason 02] Present bit in context entry is clear

screenshot can be found here:
http://arndnet.de/lkml/screenshot3.2rc1.jpg

kernel 3.1.1 is booting up flawlessly.

Any idea?

Best regards
Arnd
