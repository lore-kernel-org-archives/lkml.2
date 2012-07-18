Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2GRRdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:33:02 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:39934 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab2GRRc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:32:59 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lq387pErHR
X-RZG-CLASS-ID: mo00
Date: Wed, 18 Jul 2012 19:32:56 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] led: use correct name for /sys/devices/virtual/leds/
 entries
Message-ID: <20120718173256.GA21359@aepfle.de>
References: <1342630156-16432-1-git-send-email-olaf@aepfle.de>
 <5006EBD4.8010601@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5006EBD4.8010601@metafoo.de>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, Lars-Peter Clausen wrote:

> That's a LED trigger, not a LED. So the LED naming convention doesn't apply
> here and it does not even make sense to try to apply it. Also the patch
> breaks all users of the default-on trigger.

Thanks for the review. The real fix was applied in db3f5207, no idea why
I changed also this file. Up to now noone noticed the name change.

Olaf
