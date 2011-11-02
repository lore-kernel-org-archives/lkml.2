Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1KCAGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:06:18 -0400
Received: from ozlabs.org ([203.10.76.45]:52643 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab1KCAGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:06:15 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Stephen Boyd <sboyd@codeaurora.org>, Joe Perches <joe@perches.com>
Cc: Miche Baker-Harvey <miche@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Amit Shah <amit.shah@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        virtualization@lists.linux-foundation.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] VirtioConsole support.
In-Reply-To: <4EAAF23C.8050102@codeaurora.org>
References: <20111027173527.GA23839@phenom.dumpdata.com>  <1319751802-27013-1-git-send-email-miche@google.com> <1319770558.2529.20.camel@Joe-Laptop> <4EAAF23C.8050102@codeaurora.org>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 03 Nov 2011 08:32:13 +1030
Message-ID: <87k47itc7u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011 11:19:40 -0700, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Even better would be kmemdup().

OK, this driver is horribly unloved, and ugly.  Noone claims to really
understand it, but people keep poking it.

Ben, Christian, can you figure out what's going on?  Is it time for a
complete rewrite?

Thanks,
Rusty.
