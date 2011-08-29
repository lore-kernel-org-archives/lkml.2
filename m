Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1H2SRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:17:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51424 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab1H2SRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:17:07 -0400
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaud Lacombe <lacombar@gmail.com>, David Airlie <airlied@redhat.com>,
        Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pavel Ivanov <paivanof@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kbuild@vger.kernel.org
Date: Mon, 29 Aug 2011 20:16:53 +0200
References: <20110829141612.GB2025@gere.osrc.amd.com>
	 <1790021880.1347470.1314632844694.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
	 <20110829155501.GC2025@gere.osrc.amd.com>
	 <CACqU3MVZek9TCcZEAbJXZqy9JZs3cbzNVJpwjOhS8OoKqH_YZQ@mail.gmail.com>
	 <20110829171750.GD2025@gere.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314641813.2816.133.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 20:09 +0200, Peter Zijlstra wrote:
> > That would suck, suppose this radeon thing is the only console you've
> > got (ppc64/sparc64 don't have text mode iirc) and userspace doesn't come
> > up?
> 
> Same is true for NICs and netconsole of course. Not being able to stick
> blobs into the kernel image would so suck. 

NICs and nfsroot, I suppose can you use an initrd over tftp as well, but
really, what's the point of an in-kernel nfsroot if you need initrd
crap.
