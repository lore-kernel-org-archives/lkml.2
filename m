Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab2JCVcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:32:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab2JCVcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:32:01 -0400
Date: Wed, 3 Oct 2012 14:32:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        linux-kernel@vger.kernel.org, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Johannes Stezenbach <js@sig21.net>
Subject: Re: [GIT PULL v2] Update LZO compression
Message-Id: <20121003143200.69a50aad.akpm@linux-foundation.org>
In-Reply-To: <20121003211904.GJ16230@one.firstfloor.org>
References: <5033A78E.3080703@oberhumer.com>
	<506C14BA.70006@oberhumer.com>
	<CAFLxGvw3OqOb0UVhjtwC+CD+wtubH-O1FM7=fYFT8ztWPVPd6w@mail.gmail.com>
	<20121003140136.f2b071df.akpm@linux-foundation.org>
	<20121003211904.GJ16230@one.firstfloor.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012 23:19:04 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > No, lib/lzo has no identifiable maintainer.  I suggest you proceed as
> > follows:
> > 
> > - Post the entire patch series to lkml for review (I'd like a cc please)
> 
> Already happened, multiple people reviewed and tested.

um, I would not consider "Looks ok to me from a quick look." and "I
couldn't tell from the github view, but I assume you follow standard
coding style." to indicate a rigorous code review!

That's the problem with the git presentation: hardly anyone reads the
patches and there is no patch for a reviewer to reply to.

So please send the patches out for review.  One at a time, via email.

