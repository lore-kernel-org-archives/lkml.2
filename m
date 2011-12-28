Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1L1TVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 14:21:09 -0500
Received: from cox.rootnode.net ([89.248.165.14]:53613 "EHLO cox.rootnode.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab1L1TVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 14:21:08 -0500
From: Szymon Janc <szymon@janc.net.pl>
To: =?utf-8?q?Tom=C3=A1=C5=A1_Janou=C5=A1ek?= <tomi@nomi.cz>
Subject: Re: [REGRESSION] resume takes 10s longer due to e1b6eb3 (Bluetooth: Increase HCI reset timeout ...)
Date: Wed, 28 Dec 2011 20:21:04 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-686-pae; KDE/4.7.4; i686; ; )
Cc: Gustavo Padovan <padovan@profusion.mobi>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <20111118184017.GA5052@nomi.cz> <201112232143.20937.szymon@janc.net.pl> <20111223204849.GA23712@nomi.cz>
In-Reply-To: <20111223204849.GA23712@nomi.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201112282021.04658.szymon@janc.net.pl>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.8 (cox.rootnode.net [0.0.0.0]); Wed, 28 Dec 2011 20:21:04 +0100 (CET)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Dec 28 20:21:04 2011
X-DSPAM-Confidence: 0.9948
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4efb6c20180371804284693
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomáš,

> Tell me what you need and how can I get that, and I'm all yours.

We need to figure out why command complete event to reset command is not 
received and we get timeout for your bt chip.

So first please provide kernel debug logs and hcidump while resuming (with 
timeout set to 10s). Also for kernel logs please make sure you have kernel 
prints timestamps enabled.

hcidump -t

kernel:
echo "module bluetooth +pf" >/sys/kernel/debug/dynamic_debug/control
echo "module btusb +pf" >/sys/kernel/debug/dynamic_debug/control

-- 
Szymon K. Janc
szymon@janc.net.pl // GG: 1383435

