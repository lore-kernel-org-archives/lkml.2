Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab0FJAVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 20:21:36 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:34478 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757857Ab0FJAVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 20:21:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Nb/kO+41VpF6fC3WX5i3U1a4ryUvcEIpUreMSXC1aEM/6X6xwNnkC2RgMulE0eYxM0p2Jekclh0M5gO4qKQnEMmipu9mV/Rfn19BsvbtCJ+4MRQ1/t7z3ecUCFquJZAN;
Date: Wed, 9 Jun 2010 17:20:26 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI fixes
Message-ID: <20100609172026.088878ee@virtuousgeek.org>
In-Reply-To: <alpine.LFD.2.00.1006091611040.4506@i5.linux-foundation.org>
References: <20100609155321.299cadd9@virtuousgeek.org>
	<alpine.LFD.2.00.1006091611040.4506@i5.linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010 16:14:10 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 9 Jun 2010, Jesse Barnes wrote:
> > 
> > Nothing too big here; I do have a couple of fixes in the queue that
> > aren't included here though.  I'll be pulling them together over the
> > next couple of days.
> 
> Hmm. None of these seem to really be relevant. The fact that one is from 
> me doesn't make me any more eager to pull. Are any of these real 
> regressions (the missing parenthesis one seems to be the only one that 
> could be serious, but I didn't grep for actual use).

I wanted Bjorn's fix to avoid false regression and bug reports, but
yes, the others are just trivial patches.  I can drop them out and send
you a new tree once I pull in the other fixes if you'd prefer that.

-- 
Jesse Barnes, Intel Open Source Technology Center
