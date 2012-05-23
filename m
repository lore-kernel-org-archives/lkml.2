Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2EWGWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:22:23 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47831 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293Ab2EWGWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:22:21 -0400
X-Sasl-enc: IhWUssAIXfWZczpPHHAPEL2uRtUxarGrpoFNI4fBAuMt 1337754139
Date: Tue, 22 May 2012 23:22:17 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?iso-8859-1?Q?=22Ezequiel_Garc=EDa=22?= <elezegarcia@gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with the v4l-dvb tree
Message-ID: <20120523062217.GA19896@kroah.com>
References: <20120521160624.a5e16748fb11670778ea9b3f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521160624.a5e16748fb11670778ea9b3f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 04:06:24PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/staging/media/easycap/easycap_main.c between various commits from
> the v4l-dvb tree and commit 5df773120477 ("USB: Staging: media: easycap:
> remove err() usage") from the usb tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

This looks correct, thanks.

greg k-h
