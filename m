Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2EAW6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 18:58:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39036 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab2EAW6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 18:58:33 -0400
From: Marc Reilly <marc@cpdesign.com.au>
Reply-To: marc@cpdesign.com.au
Organization: Creative Product Design
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: mc13xxx: add I2C support, V5
Date: Wed, 2 May 2012 08:55:55 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
References: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au> <201204170921.42027.marc@cpdesign.com.au> <20120501103949.GC20224@sortiz-mobl>
In-Reply-To: <20120501103949.GC20224@sortiz-mobl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205020855.55953.marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

> > On Sunday, April 01, 2012 04:41:35 PM Marc Reilly wrote:
> > > This series (against mfd-2.6/for-next) changes the mc13xxx driver to
> > > use regmap and adds I2C support.
> > > It has a compile dependency on regmap/for-next, as the spi driver uses
> > > the recently added pad_bits config field.
> > 
> > (bump).
> > 
> > Are these changes OK to go in?
> 
> All 4 patches applied to my for-next branch.
> I had to manually apply patch #1, please verify that it's all good.

Looks good. I think I can see where it didn't apply, thanks for that. 

> I added an Acked-by: Oskar Schirmer <oskar@scara.com> to patch #4. Please
> make sure that you add the right tags to the corresponding patches in the
> future.
Apologies, will try.

Cheers,
Marc
