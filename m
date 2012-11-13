Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2KMTUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:20:21 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41329 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261Ab2KMTUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:20:16 -0500
X-Sasl-enc: 17MkbEVpqO0r0RsB0eA2m/TdfBa/CGHs/MEpgvWfYhVE 1352834416
Date: Tue, 13 Nov 2012 11:20:15 -0800
From: Greg Kroah-Hartman <greg@kroah.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: fix the spaces issue around that '->' in
 drivers/gsc_hpdi.c
Message-ID: <20121113192015.GB8677@kroah.com>
References: <1351950039-16269-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351950039-16269-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 10:40:39PM +0900, YAMANE Toshiaki wrote:
> fixed below checkpatch error.
> - ERROR: spaces prohibited around that '->' (ctx:VxW)
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/comedi/drivers/gsc_hpdi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This does not apply :(

