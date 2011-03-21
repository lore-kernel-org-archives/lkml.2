Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1CUScI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:32:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37483 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab1CUScG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:32:06 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikgG5JHimq5a2OsgsH+z+WsHO3MO6OU1q6_DzgH@mail.gmail.com>
References: <201103170129.p2H1TXG5031586@hera.kernel.org> <1300661524.2402.19.camel@pasglop>
 <AANLkTikgG5JHimq5a2OsgsH+z+WsHO3MO6OU1q6_DzgH@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 21 Mar 2011 12:31:45 -0600
X-Google-Sender-Auth: vpCCp2FgBqNEzEIJKPYJafPhDq0
Message-ID: <AANLkTi=gdksERWfFJTfXG2GebXKq9BU0BNCZ=FdZL6Qk@mail.gmail.com>
Subject: Re: powerpc/pci: Make both ppc32 and ppc64 use sysdata for pci_controller
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[reposting part of private email exchange as penance for my sins...]

On Mon, Mar 21, 2011 at 12:22 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Sun, Mar 20, 2011 at 4:52 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> Grant, what in hell makes you believe that this patch was ok to
>> merge upstream without even my Ack ?
>>
>> Yes, I told you I agree with the -principle-, but I also need to -test-
>> and review it properly which I haven't had a chance to do (and it does
>> break G5s at least it seems from the reports we are getting). In any
>> case this is clearly -NOT- within the boundaries of your devicetree
>> "tree" and should have gone through powerpc-next.
>
> Sorry Ben, I did not intend to merge that patch.  Quite simply I
> accidentally included it in my devicetree/next branch when I pushed
> out a bunch of other PCI related patches in February, and I overlooked
> that it was still in there when I sent Linus the pull request.  It was
> a complete failure on my part.  I apologize and submit myself for the
> required flogging.

A flogging schedule will be posted on the bulletin board in the lunch
room.  Sorry for the trouble.

g.
