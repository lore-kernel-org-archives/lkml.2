Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab0JLOLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 10:11:12 -0400
Received: from kroah.org ([198.145.64.141]:54120 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579Ab0JLOLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 10:11:11 -0400
Date: Tue, 12 Oct 2010 07:11:43 -0700
From: Greg KH <greg@kroah.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: [stable] dm-crypt: plain64 IV support for -stable?
Message-ID: <20101012141143.GA12143@kroah.com>
References: <20101012132511.GA24455@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012132511.GA24455@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 10:25:11AM -0300, Henrique de Moraes Holschuh wrote:
> Would it be possible to add commit 61afef614b013ee1b767cdd10325acae1db1f4d2
> "dm crypt: add plain64 iv" to -stable?

Which -stable tree?  .27, .32, .35, or any/all of them?  Please be more
specific when asking for this in the future.

> Without it, users of LTS kernels like 2.6.32 are missing important
> functionality (as in: might not be able to mount some LUKS volumes
> created on newer kernels).

Also note that this patch really looks like a "new feature", not a
bugfix or anything that matches up with what
Documentation/stable_kernel_rules.txt defines.  So I don't think that it
really is something to add to a stable kernel.

thanks,

greg k-h
