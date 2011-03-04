Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008Ab1CDRQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:16:14 -0500
Received: from kroah.org ([198.145.64.141]:38585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759801Ab1CDROd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:14:33 -0500
Date: Fri, 4 Mar 2011 09:12:56 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Timo von Holtz <tvh@informatik.uni-kiel.de>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
Message-ID: <20110304171256.GC22173@kroah.com>
References: <20110304163856.7ce5d15d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304163856.7ce5d15d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 04:38:56PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/dabusb/dabusb.c and drivers/staging/dabusb/dabusb.h
> between commit f8f4a7f5c1219571acf55f3889138b594e5b3b68 ("[media] dabusb:
> remove obsolete driver") from the v4l-dvb tree and commit
> 868788278eaa5b841ec1a810b41e156f5fba0ab5 ("Staging: dabusb: fixed coding
> style issues") from the staging tree.
> 
> I removed the files.

That sounds correct, thanks.

greg k-h
