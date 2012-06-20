Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2FTDfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 23:35:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33397 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2FTDfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 23:35:01 -0400
Date: Tue, 19 Jun 2012 20:33:12 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Andi Shyti <andi.shyti@gmail.com>
Subject: Re: [PATCH 0/4] twl4030_charger improvements.
Message-ID: <20120620022234.GA15861@lizard>
References: <20120508213518.2844.95446.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120508213518.2844.95446.stgit@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 07:40:39AM +1000, NeilBrown wrote:
> Hi,
>  this series is a resend of a previous submission with some
>  contentious patches removed and extra maintainers added.
> 
>  They allow the twl4030 to charge the backup battery (voltage and
>  current configured in board file) and allow the charger to continue
>  charging while the USB PHY is otherwise idle (no gadget module
>  loaded, or host in suspend-to-RAM).
> 
>  Anton: could you take the first three?  Do I need to split the third
>    patch into an 'MFD' part for Samuel and a power_supply part for you?

Applied the three patches (w/ Samuel's Ack).

Though, please consider addressing Andi's comments (as follow-up
patches).

Thank you guys!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
