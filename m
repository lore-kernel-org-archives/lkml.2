Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab2IJFvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 01:51:38 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:51983 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2IJFvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 01:51:33 -0400
X-Auth-Info: V1Y7I21tQ9K3z/ogPfdOW7K3/SaUmh0GpkpbDfKzj0Y=
From: Marek Vasut <marex@denx.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the hid tree with Linus' tree
Date: Mon, 10 Sep 2012 07:49:26 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Jiri Kosina <jikos@jikos.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <20120910113359.ddc30b010fcd73f00c993d23@canb.auug.org.au>
In-Reply-To: <20120910113359.ddc30b010fcd73f00c993d23@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209100749.27199.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Stephen Rothwell,

> Hi Jiri,
> 
> Today's linux-next merge of the hid tree got a conflict in
> drivers/hid/usbhid/hid-quirks.c between commit 67ddbb3e6568 ("HID: add
> NOGET quirk for Eaton Ellipse MAX UPS") from Linus' tree and commit
> 2843b673d034 ("HID: add quirk for Freescale i.MX28 ROM recovery") from
> the hid tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary (no action is required).

Looks obviously correct, thank you Stephen!

Best regards,
Marek Vasut
