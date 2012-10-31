Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423143Ab2JaQEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:04:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422946Ab2JaQEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:04:30 -0400
Date: Wed, 31 Oct 2012 17:04:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
In-Reply-To: <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1210311703560.12781@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
 <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Josh Boyer wrote:

> I have a patch that disables that.  I imagine it will be included in the
> next submission of the patchset.
> 
> You can find it here in the meantime:
> 
> http://jwboyer.fedorapeople.org/pub/0001-hibernate-Disable-in-a-Secure-Boot-environment.patch

I don't see that patch touching kernel/power/user.c, so using 's2disk' to 
suspend machine seems to be still possible even with this patch applied, 
right?

-- 
Jiri Kosina
SUSE Labs
