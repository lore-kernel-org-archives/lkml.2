Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470Ab2EKOoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:44:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33597 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756443Ab2EKOoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:44:06 -0400
X-Sasl-enc: 0jUF2rftSx6aqty9JDrptsd9gKi9hBcUUz60OfvNl4cI 1336747443
Date: Fri, 11 May 2012 07:44:02 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the usb tree
Message-ID: <20120511144402.GB5958@kroah.com>
References: <20120511151236.c554c07acc0f5809eaeb85b8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511151236.c554c07acc0f5809eaeb85b8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 03:12:36PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/quatech_usb2/quatech_usb2.c between commit 38902cf9f6be
> ("USB: remove staging quatech_usb2 driver") from the usb tree and a
> couple of commits from the staging tree.
> 
> The former removes the file, so I did that.

Wonderful, thanks for doing that.

greg k-h
