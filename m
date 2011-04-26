Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1DZSkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:40:07 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39023 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1DZSkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:40:05 -0400
Date: Tue, 26 Apr 2011 15:40:19 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiejing Zhang <kzjeef@gmail.com>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: manual merge of the tty tree with the bluetooth tree
Message-ID: <20110426184019.GD2242@joana>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jiejing Zhang <kzjeef@gmail.com>,
	Felipe Balbi <balbi@ti.com>
References: <20110426175530.d27179e2.sfr@canb.auug.org.au>
 <20110426125646.GB6272@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426125646.GB6272@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <greg@kroah.com> [2011-04-26 05:56:46 -0700]:

> On Tue, Apr 26, 2011 at 05:55:30PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's linux-next merge of the tty tree got a conflict in
> > drivers/bluetooth/hci_ldisc.c between commit 78b4a56c28c0 ("Bluetooth:
> > hci_uart: check the return value of recv()") from the bluetooth tree and
> > commit b1c43f82c5aa ("tty: make receive_buf() return the amout of bytes
> > received") from the tty tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary.
> 
> The fix looks correct to me, thanks for doing this.

It's ok to me as well, thanks for the fix!

-- 
Gustavo F. Padovan
http://profusion.mobi
