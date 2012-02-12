Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2BLQte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 11:49:34 -0500
Received: from cox.rootnode.net ([89.248.165.14]:39296 "EHLO cox.rootnode.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab2BLQtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 11:49:32 -0500
From: Szymon Janc <szymon@janc.net.pl>
To: Tomas Janousek <tomi@nomi.cz>
Subject: Re: [REGRESSION] resume takes 10s longer due to e1b6eb3 (Bluetooth: Increase HCI reset timeout ...)
Date: Sun, 12 Feb 2012 17:49:31 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-686-pae; KDE/4.7.4; i686; ; )
Cc: Gustavo Padovan <padovan@profusion.mobi>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <20111118184017.GA5052@nomi.cz> <201112282021.04658.szymon@janc.net.pl> <20120212113743.GA14271@notes.lisk.in>
In-Reply-To: <20120212113743.GA14271@notes.lisk.in>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201202121749.31792.szymon@janc.net.pl>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.8 (cox.rootnode.net [0.0.0.0]); Sun, 12 Feb 2012 17:49:30 +0100 (CET)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Feb 12 17:49:31 2012
X-DSPAM-Confidence: 0.9967
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4f37ed9b246141804284693
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I'm attaching dmesg and hcidump output.
> 
> I'm sorry for the delay, I did not have a kernel with dynamic_debug enabled
> and I didn't have time to reboot and lose my open terminals. Now I updated
> to today's kernel snapshot and enabled debugging, so as long as I don't
> have to reboot, I should be able to react quickly. :-)

Can you try with this patch applied: 
http://git.kernel.org/?p=linux/kernel/git/jh/bluetooth-
next.git;a=commit;h=30a824d82726f4d10105e5f8c1afa7ebcda17523
?

-- 
Szymon K. Janc
szymon@janc.net.pl

