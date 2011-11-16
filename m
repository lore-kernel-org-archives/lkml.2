Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab1KPU7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 15:59:03 -0500
Received: from balrog.mythic-beasts.com ([93.93.130.6]:44050 "EHLO
	balrog.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab1KPU7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 15:59:01 -0500
Date: Wed, 16 Nov 2011 20:58:48 +0000
From: Luis Henriques <henrix@camandro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1704
Message-ID: <20111116205848.61ab1ab0@hades>
In-Reply-To: <20111108194939.1ddff5af4c877850cfb9e1f9@canb.auug.org.au>
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
	<1320677484.1215.10.camel@dabdike.int.hansenpartnership.com>
	<20111108110300.e8494242e6c404142b1fe4c0@canb.auug.org.au>
	<CAO+b5-pPTt9B1se3-oGrZZ4-mScJh7_9MA29UTbOSB3QR4L38A@mail.gmail.com>
	<20111108194939.1ddff5af4c877850cfb9e1f9@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-BlackCat-Spam-Score: -46
X-Mythic-Debug: Threshold =  On = 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011 19:49:39 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> > > I don't get the WARNING any more, but now get lots of:
> > >
> > > scsi: killing requests for dead queue
> > 
> > This patch should help:
> > http://www.spinics.net/lists/linux-scsi/msg55373.html.
> 
> Thanks.  Will that be added to the scsi{,-rc-fixes} trees soon?

Any idea when this will hit mainline?  Its really annoying having all
these messages on the logs...

Cheers,
--
Luis Henriques
