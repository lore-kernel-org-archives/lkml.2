Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1KWM5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:57:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1KWM5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:57:22 -0500
Date: Wed, 23 Nov 2011 18:26:57 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Miche Baker-Harvey <miche@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Anton Blanchard <anton@samba.org>, Mike Waychison <mikew@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Eric Northrup <digitaleric@google.com>
Subject: Re: [PATCH v3 2/3] hvc_init(): Enforce one-time initialization.
Message-ID: <20111123125657.GH16665@amit-x200.redhat.com>
References: <20111108214452.28884.14840.stgit@miche.sea.corp.google.com>
 <20111108214504.28884.61814.stgit@miche.sea.corp.google.com>
 <874nybqo0o.fsf@rustcorp.com.au>
 <CAB8RdapbaueyWLJuJDE_ZdvLkRNM4sQHTxgmgO=jrnXZ6YPSmA@mail.gmail.com>
 <20111123103852.GG16665@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123103852.GG16665@amit-x200.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 23 Nov 2011 [16:08:52], Amit Shah wrote:
> With this setup, with and without patches, I can spawn two consoles
> via:
> 
> /sbin/agetty /dev/hvc0 9600 vt100
> /sbin/agetty /dev/hvc1 9600 vt100
> 
> (Strange thing is, the second one gives a 'password incorrect' error
> on login attempts, while the first one logs in fine.  I do remember
> testing multiple consoles just fine a year and a half back, so no idea
> why this isn't behaving as expected -- but it mostly looks like a
> userspace issue rather than kernel one.)

Right -- when I test this on the Fedora 11 VM I used back then, the
two consoles work just fine without these patches.  When I use
something newer (F14), I get the weird password rejection, with and
without your patches.

		Amit
