Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab1LWUsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:48:55 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:45386 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335Ab1LWUsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:48:53 -0500
Date: Fri, 23 Dec 2011 21:48:49 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Szymon Janc <szymon@janc.net.pl>
Cc: Gustavo Padovan <padovan@profusion.mobi>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [REGRESSION] resume takes 10s longer due to e1b6eb3
	(Bluetooth: Increase HCI reset timeout ...)
Message-ID: <20111223204849.GA23712@nomi.cz>
References: <20111118184017.GA5052@nomi.cz> <20111121211506.GA16081@nomi.cz> <20111223165429.GA5287@joana> <201112232143.20937.szymon@janc.net.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201112232143.20937.szymon@janc.net.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Dec 23, 2011 at 09:43:20PM +0100, Szymon Janc wrote:
> > Is this still happening? If yes I'm going to revert this patch.

Yes, it is.

> I kindly ask to not revert this patch yet as this will bring back issue on my 
> CSR dongle.

As far as I'm concerned, I don't mind either way. There's a trivial
workaround and I didn't have to think about this ever since I applied it.

> If this regression still happening I can try investigate it next week (as long 
> as Tomáš is willing to provide more detailed logs and do some tests if 
> needed).

Tell me what you need and how can I get that, and I'm all yours.

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
