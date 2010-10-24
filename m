Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab0JXCkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 22:40:18 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:41141 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab0JXCkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 22:40:16 -0400
Date: Sun, 24 Oct 2010 03:40:15 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/9] MIPS: Honor L2 bypass bit
In-Reply-To: <AANLkTinJ4wU30AaBhcvJRLZ_iw-eo9tEkds8QA1S=Nqw@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1010240325170.15889@eddie.linux-mips.org>
References: <74b5d3ba9506b2e6d885546bd6dcdaec@localhost>        <20101021125809.GA15031@linux-mips.org> <AANLkTinJ4wU30AaBhcvJRLZ_iw-eo9tEkds8QA1S=Nqw@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010, Kevin Cernekee wrote:

> FWIW, I did check the software user's manual for each of the four
> processors in the list and verified that L2B is at CONFIG2 bit 12.  It
> would be very rude for an L2 designer to redefine those bits in
> defiance of the SUM, no?

 To err is human -- people do all kinds of weird stuff, not necessarily on 
purpose.  I think it should be safe to assume the bit is used properly 
until proved otherwise.

> I also rechecked 24KE just now, and found that L2B is defined in the
> latest rev of the SUM, but in my local copy (Revision 01.02) bit 12 is
> the MSB of SS instead.  Hmmm.

 Clearly a documentation bug -- notice how the width of the field 
disagress with the bit indices quoted.

  Maciej
