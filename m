Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1AXAbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 19:31:48 -0500
Received: from tundra.namei.org ([65.99.196.166]:44515 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1AXAbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 19:31:47 -0500
Date: Mon, 24 Jan 2011 11:31:17 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Olof Johansson <olof@lixom.net>
cc: linux-kernel@vger.kernel.org, Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, Matthew Garrett <mjg@redhat.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] tpm: fix panic caused by "tpm: Autodetect itpm
 devices"
In-Reply-To: <AANLkTi=E1_Ur6GmwBRnjGRBpmSup4_1_k35ZKvBRcFtv@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1101241130460.30744@tundra.namei.org>
References: <1294370641-6791-1-git-send-email-olof@lixom.net> <AANLkTi=E1_Ur6GmwBRnjGRBpmSup4_1_k35ZKvBRcFtv@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Olof Johansson wrote:

> On Thu, Jan 6, 2011 at 7:24 PM, Olof Johansson <olof@lixom.net> wrote:
> > commit 3f0d3d016d89a5efb8b926d4707eb21fa13f3d27 adds a check for
> > PNP device id to the common tpm_tis_init() function, which in some
> > cases (force=1) will be called without the device being a member of
> > a pnp_dev. Oopsing and panics ensue.
> >
> > Move the test up to before the call to tpm_tis_init(), since it
> > just modifies a global variable anyway.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#for-linus

-- 
James Morris
<jmorris@namei.org>
