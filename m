Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1GQJS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:18:28 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52123 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754149Ab1GQJSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:18:24 -0400
X-Sasl-enc: Ud7Y4ueJlEV3Rl5W7VJiOLH7iNPMzNh/iO7Pd/tbr0y3 1310894302
Date: Sun, 17 Jul 2011 11:15:42 +0200
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Curtis McEnroe <programble@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
Message-ID: <20110717091542.GC25824@kroah.com>
References: <20110716230358.49ad03a289ee0881eb2c8821@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110716230358.49ad03a289ee0881eb2c8821@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 11:03:58PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/tm6000/tm6000-alsa.c between commit 58d73afffaac
> ("[media] tm6000: remove a check for NO_PCM_LOCK") from the v4l-dvb tree
> and commit d684aee316ec ("tm6000: Cleaned up code style in
> tm6000-alsa.c") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

That fix looks fine, thanks for doing it.

greg k-h
