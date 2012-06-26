Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab2FZPbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:31:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757161Ab2FZPbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:31:07 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Nick Piggin <npiggin@kernel.dk>,
        LKML List <linux-kernel@vger.kernel.org>, torsten.hilbrich@secunet.com,
        Richard Jones <rjones@redhat.com>, stable@vger.kernel.org,
        Marcos Mello <marcosfrm@gmail.com>
Subject: Re: [patch] block: fix infinite loop in __getblk_slow
References: <x49r4t2rul5.fsf@segfault.boston.devel.redhat.com>
	<CA+5PVA6j+deqA9n7ZsZDcSsCKTvHs4B1QMfrL4KvHVWTC=dV7A@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 26 Jun 2012 11:31:00 -0400
In-Reply-To: <CA+5PVA6j+deqA9n7ZsZDcSsCKTvHs4B1QMfrL4KvHVWTC=dV7A@mail.gmail.com>
	(Josh Boyer's message of "Tue, 26 Jun 2012 11:27:50 -0400")
Message-ID: <x49d34mrsy3.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@gmail.com> writes:

> Is this needed in addition to your earlier patch here:
>
> http://article.gmane.org/gmane.linux.kernel/1316228
>
> or is it a replacement for that?

Sorry for the confusion, it's a replacement for that patch.

Cheers,
Jeff
