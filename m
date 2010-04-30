Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab0D3Rnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:43:46 -0400
Received: from kroah.org ([198.145.64.141]:51960 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976Ab0D3Rnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:43:32 -0400
Date: Fri, 30 Apr 2010 07:44:20 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Axel Lin <axel.lin@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with the input tree
Message-ID: <20100430144420.GF1824@kroah.com>
References: <20100430155115.fbc54b24.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430155115.fbc54b24.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 03:51:15PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/input/tablet/kbtab.c between commits
> ee7aa6ce41e08c68f72b5ca8f14fb61286dc2418 ("Input: kbtab - fix incorrect
> size parameter in usb_buffer_free") and
> 331cb022d3ac1f85f7842a51495c33c629e947bc ("Input: kbtab - simplify
> kbtab_disconnect()") from the input tree and commit
> 3cc96f50329227fbf34de2459491901b6ee1c98c ("USB: rename usb_buffer_alloc()
> and usb_buffer_free() users") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

thanks for the fix.

greg k-h
