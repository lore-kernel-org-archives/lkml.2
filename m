Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab0HQRr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:47:56 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:32778
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754819Ab0HQRrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:47:49 -0400
Date: Tue, 17 Aug 2010 19:47:04 +0200
From: Michael Guntsche <mike@it-loops.com>
To: Brian Norris <norris@broadcom.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Nand support broken with v2.6.36-rc1
Message-ID: <20100817174704.GA1322@gibson.comsick.at>
References: <20100817113644.GA31317@gibson.comsick.at>
 <4C6AC037.7070205@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6AC037.7070205@broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Aug 10 10:00, Brian Norris wrote:
> One of the following two cases is likely the problem:
> (1) Your chip is supposed to use offset 0, not 5, for the BBM (i.e.,
> NAND_LARGE_BADBLOCK_POS, not NAND_SMALL_BADBLOCK_POS), and so your
> ecclayout should not be leaving byte 0 in the "oobfree" array (a
> design flaw since you first began using this chip)

First, I am just an end user so I have no access to the datasheets etc. I
just got the code from the board manufactrurer (2.6.27) and forward
port it to recent kernels.

The reason I am using a specific layout is because the bootloader on
this board expects it this way. It formats it this way in the beginning
and I cannot change that. 


> Could you send the full NAND ID string (8 bytes, not
If you can tell me where I can find that I'll be more than happy to send
it to you. But as I said I think the reason for this is this special
bootloader.

Please tell me, if you need more informations.


Kind regards,
Michael
