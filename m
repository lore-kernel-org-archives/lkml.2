Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1ACPBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:01:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745Ab1ACPBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:01:43 -0500
Date: Mon, 3 Jan 2011 16:01:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 14/15]include:media:davinci:vpss.h Typo change diable to
 disable.
In-Reply-To: <4D1DAFF5.3090108@gmail.com>
Message-ID: <alpine.LNX.2.00.1101031600510.26685@pobox.suse.cz>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com> <1293750484-1161-2-git-send-email-justinmattock@gmail.com> <1293750484-1161-3-git-send-email-justinmattock@gmail.com> <1293750484-1161-4-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-5-git-send-email-justinmattock@gmail.com> <1293750484-1161-6-git-send-email-justinmattock@gmail.com> <1293750484-1161-7-git-send-email-justinmattock@gmail.com> <1293750484-1161-8-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-9-git-send-email-justinmattock@gmail.com> <1293750484-1161-10-git-send-email-justinmattock@gmail.com> <1293750484-1161-11-git-send-email-justinmattock@gmail.com> <1293750484-1161-12-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-13-git-send-email-justinmattock@gmail.com> <1293750484-1161-14-git-send-email-justinmattock@gmail.com> <4D1DAFF5.3090108@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010, Mauro Carvalho Chehab wrote:

> Em 30-12-2010 21:08, Justin P. Mattock escreveu:
> > The below patch fixes a typo "diable" to "disable". Please let me know if this 
> > is correct or not.
> > 
> > Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Applied.

> 
> PS.: Next time, please c/c linux-media ONLY on patches related to media
> drivers (/drivers/video and the corresponding include files). Having to
> dig into a series of 15 patches to just actually look on 3 patches 
> is not nice.

Absolutely.

Justin, no kernel developer should be afraid of being CCed. But try to 
avoid really unnecessary spamming (which this was).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
