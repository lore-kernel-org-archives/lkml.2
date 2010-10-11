Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0JKHsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:48:53 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:53403 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0JKHsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:48:52 -0400
Date: Mon, 11 Oct 2010 09:48:36 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: linux-next: manual merge of the arm tree with the arm-current
 tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
References: <20101011122441.606a0643.sfr@canb.auug.org.au>
In-Reply-To: <20101011122441.606a0643.sfr@canb.auug.org.au> (from
	sfr@canb.auug.org.au on Mon Oct 11 03:24:41 2010)
X-Mailer: Balsa 2.3.14
Message-Id: <1286783316l.6006l.0l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-11 03:24:41, Stephen Rothwell wrote:
> Today's linux-next merge of the arm tree got a conflict in
> arch/arm/mach-at91/include/mach/system.h between commit
> 5c189208b606a85b4e97109af70d59f10a42fdfd ("ARM: 6436/1: AT91: Fix
> power-saving in idle-mode on 926T processors") from the arm-current tree
> and commit cb809b1a5ebffca8cf0314b788919989e8e4ab5f ("AT91: fix use of
> clock disable on idle for AT91x40 devices") from the arm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Acked-by: Anders Larsen <al@alarsen.net>

Thanks
Anders		(Author of "...6436/1...")

