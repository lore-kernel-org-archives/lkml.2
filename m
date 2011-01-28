Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab1A1Uxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 15:53:38 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:33508 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751282Ab1A1Uxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 15:53:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAHu7Qk1Ld/sX/2dsb2JhbAAMhAjLTZBsgSODOHQEhRg
X-IronPort-AV: E=Sophos;i="4.60,394,1291611600"; 
   d="scan'208";a="89632917"
Message-ID: <4D432CCD.9010205@teksavvy.com>
Date: Fri, 28 Jan 2011 15:53:33 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110127063815.GA29924@core.coreip.homeip.net> <4D414928.80801@redhat.com> <20110127172128.GA19672@core.coreip.homeip.net> <4D41C071.2090201@redhat.com> <20110128093922.GA3357@core.coreip.homeip.net> <4D42AECE.3020402@redhat.com> <20110128164057.GA6252@core.coreip.homeip.net> <4D42F686.8010104@redhat.com> <20110128173305.GC6252@core.coreip.homeip.net> <4D4307D7.8010301@redhat.com> <20110128183402.GF6252@core.coreip.homeip.net>
In-Reply-To: <20110128183402.GF6252@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry / Mauro,

I'm encouraged by all of the good dialog happening here,
and regret that I am unable to poke any further at the
issue with ir-keytable for now.

The system in question is now getting rebuilt with new/modern
userspace, and I expect the original issue to "vanish" as a result.
If I do see ir-keytable acting up again afterward,
I'll let you know.

But it will be whatever version Ubuntu 10.10 installs,
not the newer one I used earlier in this thread.

Cheers!
-Mark
