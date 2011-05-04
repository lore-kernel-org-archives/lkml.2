Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab1EDI6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:58:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54903 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750882Ab1EDI6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:58:14 -0400
Date: Wed, 4 May 2011 09:57:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/23] intel_sst: Save audio state across D3 on Medfield
Message-ID: <20110504085753.GB9254@opensource.wolfsonmicro.com>
References: <20110503163128.24853.15446.stgit@bob.linux.org.uk>
 <20110503174254.GA6545@kroah.com>
 <20110503222903.4200a6bd@lxorguk.ukuu.org.uk>
 <20110503213925.GA7453@opensource.wolfsonmicro.com>
 <20110503225316.5371c96b@lxorguk.ukuu.org.uk>
 <20110503220233.GB14080@kroah.com>
 <20110503222635.GA8035@opensource.wolfsonmicro.com>
 <20110503223237.GA25039@kroah.com>
 <20110503235917.0493fd0d@lxorguk.ukuu.org.uk>
 <20110503230630.GA26903@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503230630.GA26903@kroah.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 04:06:30PM -0700, Greg KH wrote:
> On Tue, May 03, 2011 at 11:59:17PM +0100, Alan Cox wrote:

> > Best bet is to apply Mark's patch into your git tree then apply mine on
> > top I think. Git will see the same patch in both trees and resolve it all
> > nicely for -next.

> Have a pointer to which patch that was?

It's 774fd7 (sst: fix compile error) which is in -next.
