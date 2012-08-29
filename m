Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2H2Tcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 15:32:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45787 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2H2Tck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 15:32:40 -0400
Date: Wed, 29 Aug 2012 21:32:52 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: amwang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: "netpoll: re-enable irq in poll_napi()" breaks boot with
 netconsole
Message-ID: <20120829193252.GA2767@joi.lan>
References: <20120829185329.GA2734@joi.lan>
 <20120829.145947.282734125016260299.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829.145947.282734125016260299.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 02:59:47PM -0400, David Miller wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Date: Wed, 29 Aug 2012 20:53:29 +0200
> 
> > Kernel 3.6-rc3 does not boot for me with netconsole enabled, while 3.6-rc2 did.
> > I bisected it to commit 6bdb7fe31046ac50b47e83c35cd6c6b6160a475d "netpoll:
> > re-enable irq in poll_napi()" and reverting it on top of current Linus' tree
> > restores proper behaviour (disabling netconsole does this too).
> > "Not booting" manifests as immediate hang after network card enabling.
> 
> Fix is already pending, thanks:
> 
> http://patchwork.ozlabs.org/patch/179954/

It works for me. Thanks.

Marcin
