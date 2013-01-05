Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab3AEMw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 07:52:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56967 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab3AEMwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 07:52:23 -0500
Date: Sat, 5 Jan 2013 13:52:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: kvm list <kvm@vger.kernel.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: kvm lockdep splat with 3.8-rc1+
Message-ID: <20130105125237.GA4297@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Hillf Danton <dhillf@gmail.com>, kvm list <kvm@vger.kernel.org>,
	x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
	Jiri Kosina <jkosina@suse.cz>
References: <20121225223045.GA23445@liondog.tnic>
 <CAJd=RBBsJBnDyfC5QUtRwnMFBXATrhxT9t0heNRpNv5DEqe4Fg@mail.gmail.com>
 <20121227044315.GA17472@x1.alien8.de>
 <CAJd=RBD_merz-7zBJohqHtSkgMWUcBFVn=6RzDNzJBkFwkRNZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJd=RBD_merz-7zBJohqHtSkgMWUcBFVn=6RzDNzJBkFwkRNZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 08:00:19PM +0800, Hillf Danton wrote:
> Jiri posted similar locking issue at
>         https://lkml.org/lkml/2013/1/4/380
> 
> Take a look?

Yeah, it looks like the same issue. I'll try his patch on Monday.

Thanks for letting me know.

-- 
Regards/Gruss,
Boris.
