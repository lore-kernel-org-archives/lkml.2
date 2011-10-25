Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab1JYMHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 08:07:06 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:58109 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756496Ab1JYMHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 08:07:03 -0400
X-Sasl-enc: ZBmIBAFaeEJkBcjlm3yC4nkcAzj+LViEHARt6gTCS/bI 1319544420
Date: Tue, 25 Oct 2011 14:02:57 +0200
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: linux-next: manual merge of the tty tree with Linus' tree
Message-ID: <20111025120257.GA12558@kroah.com>
References: <20111025191217.31638338379ac498fda051fb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025191217.31638338379ac498fda051fb@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 07:12:17PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/tty/serial/8250_pci.c between commit dacacc3e794c
> ("serial/8250_pci: delete duplicate data definition") from Linus' tree
> and commit 64d91cfaade2 ("8250_pci: Fix kernel panic when pch_uart is
> disabled") from the tty tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks, the fix is correct.

greg k-h
