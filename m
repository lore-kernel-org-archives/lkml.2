Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab1FPGRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 02:17:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:49184 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1FPGRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 02:17:01 -0400
Subject: Re: Oops in VMA code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Graf <agraf@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1308204171.2516.65.camel@pasglop>
References: <47FAB15C-B113-40FD-9CE0-49566AACC0DF@suse.de>
	 <BANLkTimubRW2Az2MmRbgV+iTB+s6UEF5-w@mail.gmail.com>
	 <CDE289EC-7844-48E1-BB6A-6230ADAF6B7C@suse.de>
	 <1308204171.2516.65.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 16:16:51 +1000
Message-ID: <1308205011.2516.66.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 16:02 +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2011-06-16 at 07:32 +0200, Alexander Graf wrote:
> > On 16.06.2011, at 06:32, Linus Torvalds wrote:
> 
> > Thanks a lot for looking at it either way :).
> 
> Yeah thanks ;-) Let me see what I can dig out.
> 
> First it's a load from what looks like a valid pointer to the linear
> mapping that had one byte corrupted (or more but it looks reasonably
> "clean"). It's not a one bit error, there's at least 2 bad bits (the
> 09):
> 
> DAR: c00090026236bbc0
> 
> Alex, how much RAM do you have ? If that was just a one byte corruption,
> the above would imply you have something valid between 9 and 10G. From
> the look of other registers, it seems that it could be a genuine pointer
> with just that stay "09" byte that landed onto it.

90 actually...

Anyways, doesn't tell us much more.

Ben.


