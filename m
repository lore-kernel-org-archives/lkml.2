Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1KPIrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 03:47:12 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:38263 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab1KPIrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 03:47:09 -0500
Subject: Re: [PATCH] [TRIVIAL] usb: gadget: drop "select
 USB_GADGET_S3C_HSOTG_PIO"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1321266882.20271.130.camel@x61.thuisdomein>
References: <1321225272.20271.107.camel@x61.thuisdomein>
	 <alpine.LNX.2.00.1111141055450.15187@pobox.suse.cz>
	 <1321266882.20271.130.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 09:47:07 +0100
Message-ID: <1321433227.20271.257.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 11:34 +0100, Paul Bolle wrote:
> On Mon, 2011-11-14 at 10:56 +0100, Jiri Kosina wrote:
> > I hope I have picked up everything what hasn't been picked up by 
> > appropriate maintainers (there are still some things in the queue waiting 
> > for ack, as they might bring dead code into life), please double-check 
> > that.
> 
> Thanks for handling this. I hope to double check everything within a few
> days.

0) All is OK: I've sent you eleven patches in this series. Two were
taken by maintainers (drm and unicore32). Nine are now in trivial
for-next. Two needed approval (powerpc/4xx and unicore32). powerpc/4xx
got acked, and that ack is in your commit and unicore32 got taken by a
maintainer.

1) For future series of this kind (if any): does my approach work for
you? See, I basically have a list of potential problems that I work on
in batches, but one by one. So I'll work on a handful of items on that
list, drop the false positives, send a few to maintainers and send the
rest to you. After that I quickly go do something else, as this is not
the kind of stuff I like to do for hours on end.

2) This means in such a series you'll get batches, a few days apart, of
patches each whatever-it-takes apart. Is that more work on your side?


Paul Bolle

