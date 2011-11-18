Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab1KRKGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:06:46 -0500
Received: from orion.tchmachines.com ([208.76.84.200]:52626 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab1KRKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:06:45 -0500
Message-ID: <4EC62E2F.7010702@scalemp.com>
Date: Fri, 18 Nov 2011 12:06:39 +0200
From: Eial Czerwacki <eial@scalemp.com>
Organization: ScaleMP
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101020 Remi/fc8 Thunderbird/3.1.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: screen goes black suddenly while using drm/radeon and reboot of X
 is needed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I have a two seat multiseat config using two gpus.
when I first boot the computer and starts to work with seat 0, after a
few minutes my screen goes black and it behaves like it went to sleep.

the system has two gpus, seat 1 uses an ati 5450HD at slot 1
(pcie2.0x16) and seat 0 uses an ati 3650HD at slot 1 (pciex4).

this only happens after cold reboot/power cycle, after I restart X, it
doesn't happens again.

also this doesn't occurs on seat 1 so I suspect it has to do with the
pci slot.

I've manually disabled DPMS in X but I don't think that is the issue.

I'm using kernel 3.1.1, my dmesg can be found at
http://pastebin.com/TZHvDWNe and my lspci can be found at
http://paste.pocoo.org/show/509652/

any ideas what can cause it?

Thanks

Eial.
