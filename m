Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab1LWVDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:03:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47603 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab1LWVDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:03:12 -0500
Date: Fri, 23 Dec 2011 19:03:43 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: Szymon Janc <szymon@janc.net.pl>, Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [REGRESSION] resume takes 10s longer due to e1b6eb3 (Bluetooth:
 Increase HCI reset timeout ...)
Message-ID: <20111223210343.GF5287@joana>
Mail-Followup-To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>,
	Szymon Janc <szymon@janc.net.pl>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	Linux PM mailing list <linux-pm@vger.kernel.org>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <20111118184017.GA5052@nomi.cz>
 <20111121211506.GA16081@nomi.cz>
 <20111223165429.GA5287@joana>
 <201112232143.20937.szymon@janc.net.pl>
 <20111223204849.GA23712@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20111223204849.GA23712@nomi.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomáš,

* Tomáš Janoušek <tomi@nomi.cz> [2011-12-23 21:48:49 +0100]:

> Hello,
> 
> On Fri, Dec 23, 2011 at 09:43:20PM +0100, Szymon Janc wrote:
> > > Is this still happening? If yes I'm going to revert this patch.
> 
> Yes, it is.

The commit is now reverted. It should be mainline before the 3.2 release.

	Gustavo
