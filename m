Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab2AHVPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 16:15:05 -0500
Received: from cox.rootnode.net ([89.248.165.14]:47938 "EHLO cox.rootnode.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab2AHVOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 16:14:54 -0500
From: Szymon Janc <szymon@janc.net.pl>
To: =?utf-8?q?Tom=C3=A1=C5=A1_Janou=C5=A1ek?= <tomi@nomi.cz>
Subject: Re: [REGRESSION] resume takes 10s longer due to e1b6eb3 (Bluetooth: Increase HCI reset timeout ...)
Date: Sun, 8 Jan 2012 22:14:50 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-rc7-686-pae; KDE/4.7.4; i686; ; )
Cc: Gustavo Padovan <padovan@profusion.mobi>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <20111118184017.GA5052@nomi.cz> <20111223204849.GA23712@nomi.cz> <201112282021.04658.szymon@janc.net.pl>
In-Reply-To: <201112282021.04658.szymon@janc.net.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201201082214.51277.szymon@janc.net.pl>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.8 (cox.rootnode.net [0.0.0.0]); Sun, 08 Jan 2012 22:14:49 +0100 (CET)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Jan  8 22:14:50 2012
X-DSPAM-Confidence: 0.9941
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4f0a074a152081804284693
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomáš,
 
> > Tell me what you need and how can I get that, and I'm all yours.
> 
> We need to figure out why command complete event to reset command is not
> received and we get timeout for your bt chip.

Any chance to get those logs?

-- 
Szymon K. Janc
szymon@janc.net.pl

