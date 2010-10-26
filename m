Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0JZBLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:11:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35778 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab0JZBLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:11:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OneX+F4nLobwS3YcKNfrrNi6ZwJLOD/JZXq4Cs9RKNH1YQ17bnR2ifNuvY+dYoUEee
         QN4CpMWRpK3OB3RtdRR4gJj7jYx4BaCb6yZooiy5KR/goxSawgKj9Ens/G3UWHsw2Ixk
         SvCUCwq9RSKPet6PuEGyOTB7Qw6D02u0Jjgzc=
Subject: Re: [PATCH 01/29] memstick: core: header cleanups
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitky@gmail.com>
In-Reply-To: <71249.78658.qm@web37601.mail.mud.yahoo.com>
References: <71249.78658.qm@web37601.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 03:10:57 +0200
Message-ID: <1288055457.4024.18.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 07:44 -0700, Alex Dubov wrote:
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > Received: Friday, 22 October, 2010, 4:53 PM
> > * Replace the __attribute__((packed))
> > with __packed
> 
> This introduces unnecessary noise and can be merged into a common clean-up
> patch.
And what value will that add?

> 
> > * Add struct mspro_cmdex_argument, argument for
> > MS_TPC_EX_SET_CMD
> > * Increase size of inline buffer in memstick_request to 32
> > because thats the size of registers and someone might need
> > to read them
> > all. That structure is allocated one per memstick host, so
> > its size
> > doesn't matter.
> 
> This functional changes are better be joined with the first patch which
> actually requires them (these are just 4 lines).
Not fully against that, but then what value will that add too?
Currently memstick.h host many unused structures for MS IO stuff.
And for god's sake it has MS_TPC_EX_SET_CMD declared,
so I just add the structure for its argument, whats wrong with doing
that here?

> 
> > 
> > * Add comments about few members of memstick_request
> 
> Belongs to the clean-up or a separate commenting patch.
Why?

As long as the patch is crearly readable I don't see a reason to add
more patches.


Best regards,
	Maxim Levitsky

