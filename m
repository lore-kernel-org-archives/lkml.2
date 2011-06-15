Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab1FOP30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:29:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab1FOP3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:29:25 -0400
Date: Wed, 15 Jun 2011 08:03:26 -0700
From: Greg KH <gregkh@suse.de>
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.39.1 input regression
Message-ID: <20110615150326.GA7128@suse.de>
References: <4DF85C5F.4080307@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DF85C5F.4080307@odi.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 09:16:47AM +0200, Ortwin Glück wrote:
> Hi Greg,
> 
> This patch in 2.6.39.1 breaks magicmouse support for me completely.
> a5ccaac64c17ce3cc1878a6d479a6f1b16092c24
> HID: magicmouse: ignore 'ivalid report id' while switching modes
> 
> The device will no longer work at all:
> magicmouse 0005:05AC:030D.0005: input,hidraw2: BLUETOOTH HID v0.84 Mouse
> [gandalf mouse] on 7C:6D:62:9F:DB:2D
> magicmouse 0005:05AC:030D.0005: unable to request touch data (2)
> 
> Fine in previous kernels.

This has been discussed already, and it should be fixed in Linus's tree
right now, right?

If so, can someone please send stable@kernel.org the proper fix for
this?

thanks,

greg k-h
