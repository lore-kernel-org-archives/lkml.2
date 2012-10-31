Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab2JaRVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:21:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab2JaRVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:21:45 -0400
Date: Wed, 31 Oct 2012 18:21:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
In-Reply-To: <20121031172121.14cc1215@pyramind.ukuu.org.uk>
Message-ID: <alpine.LNX.2.00.1210311821150.22374@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz> <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
 <20121031155503.1aaf4c93@pyramind.ukuu.org.uk> <alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz> <20121031170334.59833fb1@pyramind.ukuu.org.uk> <20121031171048.GA17163@srcf.ucam.org> <20121031172121.14cc1215@pyramind.ukuu.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Alan Cox wrote:

> > > > Prepare (as a root) a hand-crafted image, reboot, let the kernel resume 
> > > > from that artificial image.
> > > 
> > > It's not signed. It won't reboot from that image.
> > 
> > The kernel is signed. The kernel doesn't check the signature on the 
> > suspend image.
> 
> Which doesn't matter. How are you going to create the tampered image in
> the first place ?

Editing the suspend partition/file directly when trusted kernel is booted.

-- 
Jiri Kosina
SUSE Labs
