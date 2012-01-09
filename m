Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2AIKix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 05:38:53 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:47748 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab2AIKiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 05:38:51 -0500
Date: Mon, 9 Jan 2012 11:38:45 +0100
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
Message-ID: <20120109103845.GA30361@nomi.cz>
References: <20111118184017.GA5052@nomi.cz> <20111223204849.GA23712@nomi.cz> <201112282021.04658.szymon@janc.net.pl> <201201082214.51277.szymon@janc.net.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201201082214.51277.szymon@janc.net.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jan 08, 2012 at 10:14:50PM +0100, Szymon Janc wrote:
> > > Tell me what you need and how can I get that, and I'm all yours.
> > 
> > We need to figure out why command complete event to reset command is not
> > received and we get timeout for your bt chip.
> 
> Any chance to get those logs?

I'm sorry, I've been quite busy lately. I'll try what I can do, but no sooner
than the weekend (and even that is quite optimistic). :-(

-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
