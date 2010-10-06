Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0JFCQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 22:16:47 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:47027
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751071Ab0JFCQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 22:16:46 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2010 22:16:45 EDT
Date: Tue, 5 Oct 2010 22:10:04 -0400
From: Sean MacLennan <seanm@seanm.ca>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>, paulus <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/18] powerpc: Wire up 44x little endian boot for
 remaining 44x targets
Message-ID: <20101005221004.5dc6e1b6@lappy.seanm.ca>
In-Reply-To: <AANLkTimNeWEo5P0wXzszBiSYdh81=uhARA8KZPr7rcPf@mail.gmail.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	<1285916771-18033-6-git-send-email-imunsie@au1.ibm.com>
	<AANLkTins34TrEWj618_4XBRwGGFqRSehwWEp7jBubvsu@mail.gmail.com>
	<1286327715-sup-584@au1.ibm.com>
	<AANLkTimNeWEo5P0wXzszBiSYdh81=uhARA8KZPr7rcPf@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010 21:55:35 -0400
Josh Boyer <jwboyer@gmail.com> wrote:

> Well, Warp and Sam440EP are production boards for actual companies.
> The rest are all just eval boards.  I don't know if the board
> maintainers care either way, I was just using them as examples of
> cases where someone might.

In the warp case, I basically don't care. I know LE would break some of
our telephony drivers since we assume PPC is BE. But on the other hand,
realistically, it will never get turned on by customers anyway.

We have to provide our own .config anyway, so it really don't hurt us
as long as it doesn't break BE support.

Cheers,
   Sean
