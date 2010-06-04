Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0FDPMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 11:12:21 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:59838 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756325Ab0FDPMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 11:12:20 -0400
Date: Fri, 4 Jun 2010 11:12:03 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
Message-ID: <20100604151203.GA19468@elliptictech.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andreas Mohr <andi@lisas.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <20100603223259.GA4085@rhlx01.hs-esslingen.de>
 <alpine.LFD.2.00.1006031535570.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006031535570.8175@i5.linux-foundation.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:40 Thu 03 Jun     , Linus Torvalds wrote:
> Although one comment says it all:
> 
> 	Cons: I ordered 5. After 45 days 3 of them have failed. Too late to return.
> 
> so apparently you do need to order a lot of them to keep them going ;)

I actually still have a real floppy drive in my primary desktop.  Bought
it new in 2001, and it still worked when I used it (once!) in fall 2008.

That being said, it would have been quite frustrating if Linux oopsed
when I tried to use this piece of hardware.  It was frustrating enough
to even find a single disk to put in it :).

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
