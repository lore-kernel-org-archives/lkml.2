Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0K0QjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 11:39:16 -0500
Received: from solo.fdn.fr ([80.67.169.19]:44560 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0K0QjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 11:39:14 -0500
Date: Sat, 27 Nov 2010 17:39:12 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: microcai <microcai@fedoraproject.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linuxconsole-dev@lists.sourceforge.net
Subject: Re: [PATCH] Kernel fbcon UNICODE font support
Message-ID: <20101127163912.GO4865@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	microcai <microcai@fedoraproject.org>, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linuxconsole-dev@lists.sourceforge.net
References: <1290750825.2372.59.camel@cai.gentoo> <20101127125742.GD4865@const.famille.thibault.fr> <AANLkTi=bo4TjPFkiR8SMu3Rf06bnxXoKHCH6Ksvd7T_e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=bo4TjPFkiR8SMu3Rf06bnxXoKHCH6Ksvd7T_e@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

microcai, le Sun 28 Nov 2010 00:18:13 +0800, a écrit :
> >> But, .psf does not support that much charcount (or maybe yes, and  I
> >> need some search? )
> >
> > That's just a matter of fixing tools: the newer version of the psf
> > format already supports 2^16 glyphs.
> 
> So, new psf file format is just fine. I'll search(wirte if not exist)
> some tools to generate PSF unicode font file. ^_^

There's at least bdf2psf from the console-setup Debian package.

Samuel
