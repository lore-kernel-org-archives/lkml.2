Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab2HHOiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:38:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53582 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab2HHOiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:38:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Mack <zonque@gmail.com>
Subject: Re: [PATCH 2/6] ARM: pxa remove irq_to_gpio from eeti_ts driver
Date: Wed, 8 Aug 2012 14:38:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sven Neumann <s.neumann@raumfeld.com>, linux-input@vger.kernel.org
References: <1344430493-5304-1-git-send-email-arnd@arndb.de> <201208081419.17181.arnd@arndb.de> <50227615.1090907@gmail.com>
In-Reply-To: <50227615.1090907@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208081438.04931.arnd@arndb.de>
X-Provags-ID: V02:K0:SxmqrAfusJfNE0wEbS4JT8kNRXNCzcipe+2vQ00biAL
 vAYJI2D31t3tPbbojPzYvuuFkW+tbOnT3z969IvwfD9oDlF1tF
 3VjzOCWN7E28g2oLh0AIfxdnobXgNyBsWRYnhK8xuCV8o7zruL
 A66KfLk9QxKibEeNvXujhe4fkBYFMGY+1l0vhaqnSQ3KRMJQAw
 nkHjZtjgauJFn4q11tpnK/toftWg/tZRosHE7/TYWi4tWsejsd
 Ofgvyb1T/X+pgSSDBMEkg8dprV5xwObtH6yJVkXiNPWlrj57Jp
 LfqxgTwBuaQJUGWqpDf6KdRIorbCO7MwcwP4LEJG2lRPmz67lD
 ExoHOB3f9QIs2dfAF9xI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012, Daniel Mack wrote:
> > 
> > I've taken your patch instead now, 
> 
> Will that go to some other tree than linux-input now?

I have it in the arm-soc tree for now, but I don't really care
which tree it goes through, as long as it does. I've kept a
version of this patch in one branch with random fixes that
I try to clear out now.

Other than that, I'm fine with whatever Dmitry prefers.

	Arnd
