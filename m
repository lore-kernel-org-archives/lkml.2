Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1DVSaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 14:30:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53880 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab1DVSaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 14:30:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PYwjojeLZgyh7eGTOwVcyY5Q9izHKkZFL3IJ5PDtue4Tj9Q+pFltSKiwSGKqw32x8L
         k+k1pXiqueA0co1vXTcU9dXpfannnuOgRtYJBMoavO6LWUsFlKlvtIPae6IhhNFtUQQh
         n2dbdw6KD+CFZIs7ep81bL0Fk5QOdPEdPCJUc=
Date: Fri, 22 Apr 2011 20:30:11 +0200
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Steven Whitehouse <swhiteho@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Strange block/scsi/workqueue issue
Message-ID: <20110422183011.GD21902@mtj.dyndns.org>
References: <1302641036.2604.40.camel@mulgrave.site>
 <20110413051846.GD24161@mtj.dyndns.org>
 <20110413060651.GA27823@mtj.dyndns.org>
 <1302686454.2613.4.camel@dolmen>
 <1302703208.2613.18.camel@dolmen>
 <1302714080.2597.29.camel@mulgrave.site>
 <4DA603AF.9090202@fusionio.com>
 <1302725866.2597.33.camel@mulgrave.site>
 <20110422180158.GB21902@mtj.dyndns.org>
 <1303495578.2590.33.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303495578.2590.33.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 01:06:18PM -0500, James Bottomley wrote:
> I've proposed the minimal fixes for this cycle here:
> 
> http://marc.info/?l=linux-scsi&m=130348665328233
> http://marc.info/?l=linux-scsi&m=130348673628282
> http://marc.info/?l=linux-scsi&m=130348680328356
> 
> And I'll merge at least the scsi one.

Great, looks good to me too.

> But there's been no long term conclusion yet.

I'll clean up the workqueue conversion patch and try again.

Thank you.

-- 
tejun
