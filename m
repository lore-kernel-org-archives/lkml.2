Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab1GRX2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 19:28:07 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:56387 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750979Ab1GRX2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 19:28:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qMAlZVwv7CORoCK4jKU4roJ01C7fwcxQ182DYBTrydjir8J3IyjWtT3Lm0r872UP7oQ2Jmj3fM2gXvja3saRTslmLlSKoOmFm22l1e58T7K1BNySFr6/H8M+7Nxk69KQ;
Date: Tue, 19 Jul 2011 07:27:58 +0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: Chris Ball <cjb@laptop.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, matsumur@nts.ricoh.co.jp,
        linux-pci@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock
 frequency
Message-ID: <20110719072758.20dd400e@jbarnes-e6510>
In-Reply-To: <alpine.DEB.2.02.1107131154000.3174@lazy>
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com>
	<m2sjqa2q93.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107131031360.3174@lazy>
	<201107131835.25217.arnd@arndb.de>
	<m262n62kgf.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107131154000.3174@lazy>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 174.253.240.166 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 11:54:40 -0500 (CDT)
Manoj Iyer <manoj.iyer@canonical.com> wrote:

> 
> > On Wed, Jul 13 2011, Arnd Bergmann wrote:
> >> Not much. This card only has a 6MB/s write speed, which is well
> >> below what a 50 MHz bus can do. It mgiht be different on a fast
> >> eMMC device or a Sandisk Extreme Pro UHS-1 card.
> >
> > Okay, I see.  I think we're good for now, then -- hopefully anyone
> > using a UHS card on their laptop will see the printk when wondering
> > why their performance isn't great and get in touch with us, and we
> > can investigate more then.
> >
> > I've pushed Manoj's patch to mmc-next for 3.1 now, with the printk
> > changes and a stable@ tag.
> >
> 
> Thanks Chris!

Assuming you can't move the patch into the MMC driver itself, you can
add my acked-by for the PCI quirk addition.

Thanks,
Jesse
