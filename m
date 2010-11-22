Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0KVOZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:25:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab0KVOZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:25:29 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: CFQ and dm-crypt
References: <4CC439ED.8090400@dcs.fmph.uniba.sk>
	<x49y69b6qg6.fsf@segfault.boston.devel.redhat.com>
	<4CD185C2.8000006@dcs.fmph.uniba.sk>
	<x497hgdqkvb.fsf@segfault.boston.devel.redhat.com>
	<4CE97E06.6000207@dcs.fmph.uniba.sk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 22 Nov 2010 09:20:37 -0500
In-Reply-To: <4CE97E06.6000207@dcs.fmph.uniba.sk> (Richard Kralovic's message
	of "Sun, 21 Nov 2010 21:16:06 +0100")
Message-ID: <x49hbf9qw22.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk> writes:

> Hello,
>
> I am sorry for a late reply (it took me some time to try the patch on
> my main machine). Thank you for your work; unfortunately, I'm still
> getting a panic at early boot stages: The BUG_ON assert in
> cfq-iosched.c:cic_free_func failed, with a call trace as follows:
>
> <IRQ>
> cfq_free_io_context
> put_io_context
> cfq_put_request
> elv_put_request
> blk_finish_request

Odd... Can you give me more information on your hardware and
device-mapper setup so I can try to reproduce it?

Thanks,
Jeff
