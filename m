Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1ASTOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:14:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab1ASTOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:14:15 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Nick Piggin <npiggin@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: aio fix rcu lookup
References: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
	<x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
	<AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
	<x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikgsGHJ+q6=We_zPAivyABq+z2f6Atv6ZScLYOU@mail.gmail.com>
	<20110118190114.GA5070@quack.suse.cz>
	<AANLkTin1+B_1CV-weALdS8EYJO60BJd0b7AGWzc0wrWr@mail.gmail.com>
	<20110118235236.GA14087@quack.suse.cz>
	<AANLkTikvCkMDM9+i=44eEkX094=ZHpnQaN+541pm1icK@mail.gmail.com>
	<20110119132123.GC4246@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 19 Jan 2011 14:13:34 -0500
In-Reply-To: <20110119132123.GC4246@quack.suse.cz> (Jan Kara's message of
	"Wed, 19 Jan 2011 14:21:23 +0100")
Message-ID: <x49ei88d7vl.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>  But there's the second race I describe making it possible
> for new IO to be created after io_destroy() has waited for all IO to
> finish...

Can't that be solved by introducing memory barriers around the accesses
to ->dead?

Cheers,
Jeff
