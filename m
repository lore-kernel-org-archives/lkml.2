Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab0GTODH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:03:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0GTODD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:03:03 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
	<x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
	<x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
	<AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
	<x49eif7p3z0.fsf@segfault.boston.devel.redhat.com>
	<20100713195650.GA21044@redhat.com>
	<x49aapvp1k0.fsf@segfault.boston.devel.redhat.com>
	<20100713204236.GB21044@redhat.com>
	<x4939vfv4i0.fsf@segfault.boston.devel.redhat.com>
	<20100719203109.GE32503@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 20 Jul 2010 10:02:45 -0400
In-Reply-To: <20100719203109.GE32503@redhat.com> (Vivek Goyal's message of
	"Mon, 19 Jul 2010 16:31:09 -0400")
Message-ID: <x49k4oq45fe.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, Jul 19, 2010 at 12:08:23PM -0400, Jeff Moyer wrote:
>> So, I'm still in favor of Corrado's approach.  Are there any remaining
>> dissenting opinions on this?
>
> Nope. I am fine with moving all WRITE_SYNC with RQ_NOIDLE to sync-noidle
> tree and also marking jbd writes as WRITE_SYNC. By bringing dependent
> threads on single service tree, we don't have to worry about slice
> yielding.
>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

Corrado, would you mind reposting the patches and adding:

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Tested-by: Jeff Moyer <jmoyer@redhat.com>

Thanks!
Jeff
