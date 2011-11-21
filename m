Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab1KUVPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:15:11 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:35229 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab1KUVPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:15:09 -0500
Date: Mon, 21 Nov 2011 22:15:07 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Szymon Janc <szymon@janc.net.pl>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [REGRESSION] resume takes 10s longer due to e1b6eb3
	(Bluetooth: Increase HCI reset timeout ...)
Message-ID: <20111121211506.GA16081@nomi.cz>
References: <20111118184017.GA5052@nomi.cz> <20111121152506.GB15633@fusion.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111121152506.GB15633@fusion.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On Mon, Nov 21, 2011 at 05:25:06PM +0200, Johan Hedberg wrote:
> It might be worth to try out the two patches I just sent to
> linux-bluetooth for HCI command failure tracking. They make sure that
> failures are properly caught which should help avoid triggering the
> timeout in certain scenarios (and yours might be one of them).

No, these don't help. :-(

-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
