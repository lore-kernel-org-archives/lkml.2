Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab1DRSRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:17:22 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:32899 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab1DRSRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:17:19 -0400
Date: Mon, 18 Apr 2011 20:08:13 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ciprian Docan <docan@eden.rutgers.edu>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael, J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend/resume - slow resume
Message-ID: <20110418180813.GA18469@electric-eye.fr.zoreil.com>
References: <Pine.SOC.4.64.1104150931390.1320@er3.rutgers.edu> <BANLkTinO+HFq+Mgg1aUz9V==zYs7qSBtDw@mail.gmail.com> <Pine.SOC.4.64.1104151122330.1320@er3.rutgers.edu> <BANLkTi=Gq5thZk2f1nWTz3dDA5Non8ANZg@mail.gmail.com> <20110417101731.GA17986@electric-eye.fr.zoreil.com> <BANLkTi=tPc6NmUuTYqbVZduNRNbE=-c34Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=tPc6NmUuTYqbVZduNRNbE=-c34Q@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> :
[lots of silly bugs]

Ok. it should be fixed for wednesday.

[...]
>  - unload not on close, but on device unregister (iow not when you do
> "ifconfig eth0 down", but when the "eth0" device really goes away)

Without further action, the firmware(s) will thus be locked in until the
driver is removed. 

> But as mentioned, the above is (a) just my gut feel - please discuss -
> and (b) I really think that leaving this to the network driver has
> been shown to continually result in the drivers doing the firmware
> load/unload in all the wrong places.

As long as it can be fixed... If the 60s delay is removed and the firmware
loading emits some messages for programmer barbie, I am more than happy.

If someone can tell me where Realtek's firmware should be sent to as David
W. seems to be busy, it will be perfect.

-- 
"Lack of vision" Ueimor
