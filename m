Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab1CXScM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:32:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45054 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab1CXScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:32:10 -0400
Date: Thu, 24 Mar 2011 18:32:05 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [RFC PATCHv2 0/4] Support for OTP memory
Message-ID: <20110324183205.GI3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <AANLkTim3kMCE=LhCRcUDif8ENSA-E-_Xga5cDSYs0x25@mail.gmail.com>
 <20110324174722.GH3130@pulham.picochip.com>
 <AANLkTinDWA1xU1G0kBk8XPr_ZaRgHtBQP60DX6-x3tsn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinDWA1xU1G0kBk8XPr_ZaRgHtBQP60DX6-x3tsn@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 01:56:17PM -0400, Mike Frysinger wrote:
> just an overview note here ... the Blackfin OTP is actually IP we
> bought from someone (not sure if i can say more, although i dont know
> the details myself ... i'd have to go ask around), so much of the
> feedback i give about the structure of it most likely (hopefully) be
> applicable to other people who have purchased this IP.  if/when anyone
> who is also using this IP steps forward, we could even see about
> generalizing the bfin-otp driver.

Yes, we have a similar thing here - a block of OTP from an IP vendor and 
a wrapper to provide an AXI interface.  As far as I know there are only 
a few OTP vendors so there may well be plenty of common code in 
different OTP implementations.

Jamie
