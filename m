Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1JPVDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 17:03:31 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57875 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607Ab1JPVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 17:03:29 -0400
Subject: Re: Please include const-sections into linux-next
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <20111016033514.GC26654@one.firstfloor.org>
References: <20111013233818.GB26654@one.firstfloor.org>
	 <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
	 <20111016033514.GC26654@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Oct 2011 16:03:26 -0500
Message-ID: <1318799006.2995.1.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-16 at 05:35 +0200, Andi Kleen wrote:
> > I have no idea why, though.
> 
> Thanks for testing.
> 
> Yes it's hard to tell with plain gcc (before 4.7)
> I have a special gcc patch to tell me the other symbol :)
> 
> Usually it's because some other symbol is wrong. In this 
> case it must be in the same translation unit.
> 
> Can you please do
> 
> make mm/percpu.i 
> 
> on that build and send me the percpu.i in private email?

OK, so after fixing up that one, the next failure is:

drivers/net/fealnx.c:95: error: version causes a section type conflict
drivers/net/fealnx.c:1944: error: fealnx_pci_tbl causes a section type conflict

James


