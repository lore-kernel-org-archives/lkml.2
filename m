Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab2KLWAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 17:00:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57034 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2KLWAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 17:00:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH] cpuidle: add Calxeda SOC idle support
Date: Mon, 12 Nov 2012 22:00:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1352330622-13616-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1352330622-13616-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211122200.07901.arnd@arndb.de>
X-Provags-ID: V02:K0:wqEGIy5N7LikRe8wJunyufwRnzsOt3nKSZGynHCJfPp
 PWWVdZTk6mdC8MIO7K28lMCc9e/waQpmK6Gv+I8ud0FHOpya8g
 CQztFp5HvL8kxobQn7MCY4/ZYXxQvmw+7x7DHcYfHhMcgNSsr8
 4lFN0R1RIlOZmXN80HzDv32P6wfzyqlvyNIh0CIYju9GFHrOoE
 EYww+OmsImrte3xQdhWDtf3lxJT/XDQm60u0e0ZmoudYnwSIvk
 pKpyyiZyWU95I3sqbsHZnIKO4CI0ohwLHzLnsH72ySn2NzMLE4
 LXg4QQY0Qzos9gF7MKS+eKi0h5ndFrGUTC9BXoL+l4d7ndjQg4
 qZEv6XaDrgQnztHWo2qc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2012, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Add support for core powergating on Calxeda platforms. Initially, this
> supports ECX-1000 (highbank), but support will be added for ECX-2000
> later.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> It's not really clear where we want ARM cpuidle drivers. We're moving
> everything else out of arch/arm, and my understanding is Len doesn't want
> them in drivers/idle. It seems kind of silly to me to have the framework
> and drivers in 2 places. I've put this in drivers/cpuidle, but it doesn't
> make any difference to me.

Fine with me. I just don't want in in arch/arm because I'm guessing this will
be shared with arm64, which in turn shares idle (and other) drivers with various
powerpc, mips and x86 socs.

	Arnd
