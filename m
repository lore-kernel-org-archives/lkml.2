Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0LPQkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:40:11 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33133 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446Ab0LPQkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:40:09 -0500
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event
 handling, take#2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, jeff@garzik.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kay.sievers@vrfy.org, jack@suse.cz
In-Reply-To: <4D0A400F.5090608@kernel.dk>
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
	 <4D0A3EE1.4050404@kernel.org>  <4D0A400F.5090608@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 11:38:38 -0500
Message-ID: <1292517519.3024.19.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 17:36 +0100, Jens Axboe wrote:
> On 2010-12-16 17:31, Tejun Heo wrote:
> > On 12/08/2010 08:57 PM, Tejun Heo wrote:
> >> This is the second take of in-kernel-disk-event patchset which
> >> implements in-kernel disk event handling framework and adds support
> >> for it to sr and sd.  This is largely to move media presence polling
> >> into kernel as userspace implementation turned out to be quite
> >> problematic over the years.
> > 
> > Kay, Jens, James, how does this look to you guys?
> 
> I like the concept, this is probably what we should have done all along.
> The user space method has been tried and failed. So I was mostly laying
> it low waiting for feedback before integrating this.

Me too pretty much ... event driven is nice, but it only really works if
the userspace stuff will stop polling ...

James

> Kay?



