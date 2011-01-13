Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab1AMWTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:19:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab1AMWTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:19:33 -0500
Date: Thu, 13 Jan 2011 23:19:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Milan Broz <mbroz@redhat.com>
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, linux-doc@vger.kernel.org,
        "Randy Dunlap (maintainer:DOCUMENTATION)" <rdunlap@xenotime.net>,
        "Thomas Weber (commit_signer:1/3=33%)" <weber@corscience.de>,
        "Mike Frysinger (commit_signer:1/3=33%)" <vapier.adi@gmail.com>,
        "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Documentation: dm-crypt: update cryptsetup homepage
In-Reply-To: <4D2F784E.9080103@redhat.com>
Message-ID: <alpine.LNX.2.00.1101132319200.26685@pobox.suse.cz>
References: <1294956113-6630-1-git-send-email-andrea.gelmini@gelma.net> <4D2F784E.9080103@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Milan Broz wrote:

> On 01/13/2011 11:01 PM, Andrea Gelmini wrote:
> > Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> > ---
> >  Documentation/device-mapper/dm-crypt.txt |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
> > index 59293ac..6b5c42d 100644
> > --- a/Documentation/device-mapper/dm-crypt.txt
> > +++ b/Documentation/device-mapper/dm-crypt.txt
> > @@ -41,7 +41,7 @@ Example scripts
> >  ===============
> >  LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
> >  encryption with dm-crypt using the 'cryptsetup' utility, see
> > -http://clemens.endorphin.org/cryptography
> > +http://code.google.com/p/cryptsetup/
> 
> yes, that's the upstream page for cryptsetup/LUKS now, I will probably add some
> page describing dm-crypt kernel target there too.
> 
> Acked-by: Milan Broz <mbroz@redhat.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
