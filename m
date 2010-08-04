Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab0HDNsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:48:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:50963 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab0HDNsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:48:04 -0400
Subject: Re: [GIT PULL] iBFT features for v2.6.36 .. Question about
 LinuxCon.
From: James Bottomley <James.Bottomley@suse.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@kernel.org>
Cc: torvalds@linux-foundation.org, Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek <konrad@hera.kernel.org>,
        linux-kernel@vger.kernel.org, lenb@kernel.org, michaelc@cs.wisc.edu,
        mcb30@ipxe.org
In-Reply-To: <20100804133830.GA4789@phenom.dumpdata.com>
References: <20100802143642.GA15428@hera.kernel.org>
	 <20100802195248.GB32503@andromeda.dapyr.net> <4C572A13.4010303@zytor.com>
	 <201008022108.04024.konrad@kernel.org> <4C577EFA.4070003@zytor.com>
	 <4C582918.5080602@redhat.com> <4C58A4E7.4030800@zytor.com>
	 <20100804133830.GA4789@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 09:47:27 -0400
Message-ID: <1280929647.2761.3.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 09:38 -0400, Konrad Rzeszutek Wilk wrote:
> If that is the case, ping! Please pull this in before you pull in
> James's tree as he has patches (and post-post merge patches) that
> depend
> on this tree.

Actually, there's no dependency ... the pull I sent is the
non-post-merge piece.  It goes in independently of anyone else's tree.
Post merge will wait on the resolution of the iBFT pull

James


