Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab0D3Rtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:49:53 -0400
Received: from kroah.org ([198.145.64.141]:51958 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933377Ab0D3Rnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:43:32 -0400
Date: Fri, 30 Apr 2010 07:44:33 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Axel Lin <axel.lin@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with the input tree
Message-ID: <20100430144433.GG1824@kroah.com>
References: <20100430155108.6847891f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430155108.6847891f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 03:51:08PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/input/tablet/acecad.c between commits
> 2ef2ed597669f5e120d0c51c295f00e34b2f0801 ("Input: acecad - fix incorrect
> size parameter in usb_buffer_free") and
> 5492f6f801c81c9663417cd8e48e759775977c83 ("Input: acecad - simplify
> usb_acecad_disconnect()") from the input tree and commit
> 3cc96f50329227fbf34de2459491901b6ee1c98c ("USB: rename usb_buffer_alloc()
> and usb_buffer_free() users") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks for the fixup.

greg k-h
