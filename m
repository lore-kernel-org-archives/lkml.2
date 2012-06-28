Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2F1VD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 17:03:57 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:37154 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2F1VDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 17:03:55 -0400
Message-ID: <1340917430.3821.2.camel@lorien2>
Subject: Re: linux-next: Tree for Jun 27 (eliminated_printk)
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: shuahkhan@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Date: Thu, 28 Jun 2012 15:03:50 -0600
In-Reply-To: <20120628201601.GB12471@srcf.ucam.org>
References: <20120627132217.f8bbdd1f467711419123d188@canb.auug.org.au>
	 <4FEB340D.3040908@xenotime.net> <1340814569.16533.53.camel@joe2Laptop>
	 <20120628085226.af0623e39a282192935047c3@canb.auug.org.au>
	 <1340914459.3821.0.camel@lorien2> <20120628201601.GB12471@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 21:16 +0100, Matthew Garrett wrote:
> On Thu, Jun 28, 2012 at 02:14:19PM -0600, Shuah Khan wrote:
> 
> > Has this bean fixed in June 28th tree??
> 
> I dropped the patches from my -next branch. I'll wait to hear that the 
> pre-requisites have gone in - alternatively, Joe, feel free to add my 
> SoB and have them pushed through whichever tree takes the first in the 
> series.
> 

ok Worked around for now by enabling CONFIG_THINKPAD_ACPI_DEBUG and
CONFIG_FUJITSU_LAPTOP_DEBUG. Just in case others need a work around.

-- Shuah


