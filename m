Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab2DLSle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:41:34 -0400
Received: from 1wt.eu ([62.212.114.60]:65062 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757772Ab2DLSld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:41:33 -0400
Date: Thu, 12 Apr 2012 20:40:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120412184058.GO8203@1wt.eu>
References: <20120411231102.GA6404@kroah.com> <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com> <20120412002927.GA23167@kroah.com> <CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com> <20120412011313.GA23764@kroah.com> <CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com> <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 07:49:34PM +0300, Felipe Contreras wrote:
> On Thu, Apr 12, 2012 at 5:46 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > A revert is the same as a patch.  It needs to be in Linus's tree before
> > I can add it to the stable releases.
> 
> Right, because otherwise people's systems would actually work.
> 
> But hey, as I said, following rules is more important, regardless of
> what the rules are, and why they are there. The rules that actually
> triggered this issue in v3.3.1, as this is not in v3.3.
> 
> You could just accept that the patch should have never landed in
> v3.3.1 in the first place, but it's much easier to arbitrarily keep
> stacking patches without thinking too much about them.
> 
> I guess I'll better use Linus's releases for now and go to v3.3.

Felipe, you're unfair to Greg. You're saying this because you don't know
what it's like to be on the side of the guy who has to decide whether
to apply a patch or not, which basically means whether to risk breaking
systems or to leave broken systems as they are.

Most stable users will switch from a stable version to another one
in a next release, and these users do not want any regression. This
means that we absolutely don't want to risk that a stable version
has a fix that is missing from a newer version. Yes this is a crappy
and annoying process but it's the only way to ensure that fixes don't
get lost during an upgrade.

BTW, it works because if we're discussing this here, it's because
this final fix or revert appears to be missing from mainline. After
the discussion I'm sure it will be there.

Last point is that stable maintainers are not your slaves. If you know
how to patch your mainline kernel to apply a stable patch, you also
know how to apply the patch you're pointing to. It's quite easy and
many of us do that. *All* the kernels I'm using are stable + a few
local patches and I don't see where the problem is. So please be a bit
more constructive. Make your job by ensuring that the fix you want is
in mainline then pass the commit ID to Greg so that he can merge it in
next release. You'll feel relieved and everyone will be glad to benefit
from this fix.

Willy

