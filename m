Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422848Ab2JaPzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:55:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023Ab2JaPzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:55:08 -0400
Date: Wed, 31 Oct 2012 16:55:04 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Josh Boyer <jwboyer@gmail.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
In-Reply-To: <20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
Message-ID: <alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz> <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
 <20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Alan Cox wrote:

> All this depends on your threat model. If I have physical access to
> suspend/resume your machine then you already lost. If I don't have
> physical access then I can't boot my unsigned OS to patch your S4 image
> so it doesn't matter.

Prepare (as a root) a hand-crafted image, reboot, let the kernel resume 
from that artificial image.

It can be viewed as a very obscure way of rewriting the kernel through 
/dev/mem (which is obviously not possible when in 'secure boot' 
environment).

-- 
Jiri Kosina
SUSE Labs
