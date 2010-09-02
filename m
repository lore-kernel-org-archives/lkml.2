Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0IBO2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:28:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44221 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0IBO2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:28:30 -0400
To: Jan Engelhardt <jengelh@medozas.de>
CC: neilb@suse.de, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
In-reply-to: <alpine.LNX.2.01.1009021625050.14798@obet.zrqbmnf.qr> (message
	from Jan Engelhardt on Thu, 2 Sep 2010 16:25:47 +0200 (CEST))
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
References: <20100826183340.027591901@szeredi.hu> <20100827170551.19616048@notabene> <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu> <20100827213502.31af4a4c@notabene> <E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu> <20100829144207.4fbf2713@notabene> <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
 <alpine.LNX.2.01.1009021513040.10859@obet.zrqbmnf.qr> <20100902233200.586fcb31@notabene> <alpine.LNX.2.01.1009021625050.14798@obet.zrqbmnf.qr>
Message-Id: <E1OrAm5-0002eF-Hw@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 02 Sep 2010 16:28:21 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Jan Engelhardt wrote:
> There ought to be a reason that other implementations offer
> doing multiple branches with a single vfsmount.

Overdesign.

Thanks,
Miklos
