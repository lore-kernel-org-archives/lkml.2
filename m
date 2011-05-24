Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1EXAEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 20:04:47 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:50757 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753461Ab1EXAEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 20:04:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=C2qK57XYvzp5ETy3p13O+LNOWNgPV949hUfYYN3+m5BO7Xuc10ujHY7PBMqohOCFxFVAK9c/B1iocTSTq41U900+mfQKV5lH5gKu0VL+eqBU0yXkv3LLOP2NfsaQJvAg;
Date: Mon, 23 May 2011 17:04:30 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI changes
Message-ID: <20110523170430.04a773c2@jbarnes-vaio.home>
In-Reply-To: <20110523.171617.1123528853189250599.davem@davemloft.net>
References: <20110523134339.609508fe@jbarnes-vaio.home>
	<20110523.171617.1123528853189250599.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 204.16.154.129 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 17:16:17 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> From: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date: Mon, 23 May 2011 13:43:39 -0700
> 
> > The following changes since commit
> > 2f666bcf757cb72549f360ef6da02f03620a48b6:
> > 
> >   Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-04-19 18:32:57 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next
> > 
> > Ok, with the recent fixes to the resource code, we ought to be able to
> > re-enable the code that tries to reallocate bridge resources as
> > needed.  As with last time we tried this, we'll keep the revert trigger
> > light; if this causes any problems we can't quickly root cause we'll
> > yank it back out.
> > 
> > Other than that, there are a few enabling features for PCIe 2.1
> > extensions here, and some support code for KVM, along with the usual
> > collection of fixes.
> 
> Jesse, I submitted a warning fixe a few months ago and they don't
> seem to be integrated.
> 
> http://marc.info/?l=-pci&m=130146645206948&w=2

Arg, sorry Dave.  I remember seeing that patch even, but didn't see it
in patchwork when I did my last pass.  I'll queue it up for my next
pull.  IIRC, ppc64 has a similar issue, and Ben ran into the same
multiple usage issue, but I don't remember how he solved it.  At any
rate, this fix looks fine.

Thanks,
Jesse
