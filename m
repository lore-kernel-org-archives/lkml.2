Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1KNJ4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 04:56:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab1KNJ4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:56:32 -0500
Date: Mon, 14 Nov 2011 10:56:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] usb: gadget: drop "select
 USB_GADGET_S3C_HSOTG_PIO"
In-Reply-To: <1321225272.20271.107.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1111141055450.15187@pobox.suse.cz>
References: <1321225272.20271.107.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Nov 2011, Paul Bolle wrote:

> 2) This concludes this ad hoc series of Kconfig cleanups: select
> statements with bogus Kconfig symbols. On to the next series, perhaps...

I hope I have picked up everything what hasn't been picked up by 
appropriate maintainers (there are still some things in the queue waiting 
for ack, as they might bring dead code into life), please double-check 
that.

Thanks,

-- 
Jiri Kosina
SUSE Labs
