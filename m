Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1I1DCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 23:02:30 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57351 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558Ab1I1DC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 23:02:28 -0400
X-Sasl-enc: BfZiSRK+p5Aqk1WvgP9YBTYoK6BTpWsScUxtj+smAdYj 1317178947
Date: Tue, 27 Sep 2011 07:18:54 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Igor M. Liplianin" <liplianin@netup.ru>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
Message-ID: <20110927141854.GA23403@kroah.com>
References: <20110927161055.05bbb0586fffbfbb2307f30b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927161055.05bbb0586fffbfbb2307f30b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 04:10:55PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/misc/altera-stapl/altera.c between commit cff4fa8415a3 ("[media]
> altera-stapl: it is time to move out from staging") from the v4l-dvb tree
> and commit 99c978529a40 ("staging: Add module.h to drivers/staging
> users") from the staging tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks fine, thanks.

greg k-h
