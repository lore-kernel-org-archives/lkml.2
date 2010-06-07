Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0FGE5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 00:57:04 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:51851 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab0FGE5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 00:57:01 -0400
Date: Mon, 7 Jun 2010 07:56:31 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] rtc: driver for the DryIce block found in i.MX25 chips
Message-ID: <20100607045631.GF14583@jasper.tkos.co.il>
References: <0173f18c60cb4d1f8a0d123da6cd3cfca0224788.1275456869.git.baruch@tkos.co.il>
 <20100604145304.b2cfca17.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604145304.b2cfca17.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Fri, Jun 04, 2010 at 02:53:04PM -0700, Andrew Morton wrote:
> On Wed,  2 Jun 2010 08:37:21 +0300
> Baruch Siach <baruch@tkos.co.il> wrote:
> 
> > This driver is based on code from Freescale which accompanies their i.MX25 PDK
> > board, with some cleanup.
> 
> Do we know who at freescale worked on this?  Are there any signoffs or
> attributions we could be adding?

This driver is part of a huge patch that Freescale distribute with their 
evaluation board. No specific signoffs on this one.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
