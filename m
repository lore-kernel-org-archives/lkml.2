Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab0JFONT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:13:19 -0400
Received: from kroah.org ([198.145.64.141]:54387 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759052Ab0JFONS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:13:18 -0400
Date: Wed, 6 Oct 2010 07:05:56 -0700
From: Greg KH <greg@kroah.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Jiri Kosina <jkosina@suse.cz>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: linux-next: manual merge of the usb tree with the trivial tree
Message-ID: <20101006140556.GA19537@kroah.com>
References: <20101006141414.abf7431f.sfr@canb.auug.org.au>
 <20101006061927.GA2659@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006061927.GA2659@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 09:19:27AM +0300, Felipe Balbi wrote:
> On Tue, Oct 05, 2010 at 10:14:14PM -0500, Stephen Rothwell wrote:
> >Hi Greg,
> >
> >Today's linux-next merge of the usb tree got a conflict in
> >drivers/usb/musb/musb_gadget.c between commit
> >7f26b3a7533bbc1ddd88b297c935ee4da8f74cea ("drivers/usb: Remove
> >unnecessary return's from void functions") from the trivial tree and
> 
> funny that I wasn't CCed to that one :-(

It was 'trivial' patches, which don't always get sent to the individual
developer unfortunately.

sorry,

greg k-h
