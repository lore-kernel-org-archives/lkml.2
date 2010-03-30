Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0C3Vck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 17:32:40 -0400
Received: from kroah.org ([198.145.64.141]:54212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab0C3Vcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 17:32:36 -0400
Date: Tue, 30 Mar 2010 14:17:58 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>, linux-mmc@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [patch 109/123] s3cmci: initialize default
	platform data no_wprotect and no_detect with 1
Message-ID: <20100330211758.GF15032@kroah.com>
References: <20100313001514.672290530@kvm.kroah.org> <4B9E5D79.6070203@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9E5D79.6070203@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 05:16:57PM +0100, Stefan Bader wrote:
> This patch does not seem to be applied to 2.6.32.y while the one
> 
> [patch 108/123] s3cmci: s3cmci_card_present: Use no_detect to decide whether
> there is a card detect pin
> 
> is. I checked and the only problem that makes it fail is the uncorrected comment
> above (revised patch attached)

Thanks, now applied.

greg k-h
