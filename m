Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1CRNfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:35:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756436Ab1CRNfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:35:15 -0400
MIME-Version: 1.0
In-Reply-To: <1300427072.22236.1277.camel@pasglop>
References: <1300427072.22236.1277.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 Mar 2011 06:34:25 -0700
Message-ID: <AANLkTinLb0sg1H6GDbZiddqGQ4a0=GRLYFJbL0G1Kv62@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git next branch
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 10:44 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> Here are the changes for this merge window for powerpc. One highlight
> is irq data conversion so we can get rid of the legacy stuff. The new
> Dynamic DMA windows for pSeries should also improve performances for
> some devices nicely on more recent machines/firmwares. Plus a little
> pack of embedded things.

Ok, I got a conflict with the of_platform_driver() removal which
looked pretty trivial, but since I don't have a ppc cross-compile
thing I couldn't even test-compile the end result. Please take a look
to see that it went ok..

                      Linus
