Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161697Ab2CPP3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:29:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48795 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032894Ab2CPP3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:29:06 -0400
X-Sasl-enc: MxVRCKvgPrKPXPFtqT7NL+7AAIkC86l32Gfs3OcrVf7D 1331911745
Date: Fri, 16 Mar 2012 08:29:03 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: manual merge of the char-misc tree with the powerpc
 tree
Message-ID: <20120316152903.GG28696@kroah.com>
References: <20120316165207.5a4f0985863b5ae7c50bdd81@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120316165207.5a4f0985863b5ae7c50bdd81@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 04:52:07PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the char-misc tree got a conflict in
> drivers/char/viotape.c between commit ba7a4822b48f ("powerpc: Remove some
> of the legacy iSeries specific device drivers") from the powerpc tree and
> commit 5fb15db4376f ("char: Fix typo in viotape.c") from the char-misc
> tree.
> 
> The former removed this file, so I did that.

Sounds good to me, thanks.

greg k-h
