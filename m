Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1AKNp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:45:59 -0500
Received: from 7.77.mail-out.ovh.net ([91.121.62.29]:47392 "HELO
	77.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755405Ab1AKNp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:45:56 -0500
X-Greylist: delayed 3115 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2011 08:45:56 EST
Message-ID: <4D2C3800.4080509@example.com>
Date: Tue, 11 Jan 2011 11:59:12 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Error in linux-2.6.37-git5 in btrfs in ctree.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 4035788217071464728
X-Ovh-Remote: 79.185.217.3 (adtf3.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-Ovh-Tracer-Id: 4297559944583475480
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There is an error in here:

In file included from fs/btrfs/ctree.c:21:
fs/btrfs/ctree.h:1003: error: field ‘super_kobj’ has incomplete type
fs/btrfs/ctree.h:1074: error: field ‘root_kobj’ has incomplete type

Kernel fails to build. linux-2.6.37-git5

-- 
"Wiedza to władza. Ale niewiedza, niestety, nie oznacza jeszcze
braku władzy." Niels Bohr
NP: Patrick O'Hearn - Gradual Understanding
NB: 2.6.37-next-20110110
