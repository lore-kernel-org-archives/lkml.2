Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1DZM6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:58:51 -0400
Received: from kroah.org ([198.145.64.141]:44588 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab1DZM6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:58:49 -0400
Date: Tue, 26 Apr 2011 05:56:46 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiejing Zhang <kzjeef@gmail.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: manual merge of the tty tree with the bluetooth tree
Message-ID: <20110426125646.GB6272@kroah.com>
References: <20110426175530.d27179e2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426175530.d27179e2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 05:55:30PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/bluetooth/hci_ldisc.c between commit 78b4a56c28c0 ("Bluetooth:
> hci_uart: check the return value of recv()") from the bluetooth tree and
> commit b1c43f82c5aa ("tty: make receive_buf() return the amout of bytes
> received") from the tty tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

The fix looks correct to me, thanks for doing this.

greg k-h
