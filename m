Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab2BLRPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 12:15:21 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:53554 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632Ab2BLRPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 12:15:18 -0500
Date: Sun, 12 Feb 2012 18:15:14 +0100
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
Message-ID: <20120212171514.GA22073@nomi.cz>
References: <20111118184017.GA5052@nomi.cz> <201112282021.04658.szymon@janc.net.pl> <20120212113743.GA14271@notes.lisk.in> <201202121749.31792.szymon@janc.net.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201202121749.31792.szymon@janc.net.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 12, 2012 at 05:49:31PM +0100, Szymon Janc wrote:
> Can you try with this patch applied: 
> http://git.kernel.org/?p=linux/kernel/git/jh/bluetooth-
> next.git;a=commit;h=30a824d82726f4d10105e5f8c1afa7ebcda17523
> ?

Yes. It no longer waits 10 seconds. Bluetooth works fine both before and after
suspend/resume (just so you don't have to ask). Thanks.

-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
