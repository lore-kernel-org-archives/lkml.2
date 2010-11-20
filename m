Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab0KTKVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 05:21:30 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57173 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab0KTKV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 05:21:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tGhyw7GClpR7QYMNiHxertH1LqqJ3w4WnBhIJWlCNAm2sU96s+7TJVONL2giUvg/cA
         ZUb5+P2pP3BizwQYggQh/6zvePyLt4mYMEy1YxZD7mE8M+m5xu8sG+m6idLx6clVRX/D
         MYE2CFXiRiXYh0BI23u9bt9W/DVhaqEegypqc=
Date: Sat, 20 Nov 2010 11:21:24 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Daniel Otte <daniel.otte@rub.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Trouble with ft2232
Message-ID: <20101120102124.GC11984@localhost>
References: <4CB4ACCA.9090407@rub.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB4ACCA.9090407@rub.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 08:45:30PM +0200, Daniel Otte wrote:
> Hi Johan,
> I have some trouble with the driver for the FT2232D.
> It worked flawlessly the last time I checked (around August) but now it seems to
> have troubles.

This could be related to a change that was incorrectly made to the
DTR/RTS handling.  This change has later been reverted (commit
677aeafe19e88c282af74564048243ccabb1c590 upstream).

Could you see if 2.6.37-rc2 works as it should? The revert will also be
part of 2.6.36.1 (and 2.6.35.9) soon to be released.

> The device is correctly identified and /dev/ttyUSB0 and /dev/ttyUSB1 are
> created, but at least /dev/ttyUSB1 does not transmit or receive data.
> I'm running Kernel 2.6.32-25 on Ubuntu 10.04 but I could also verify this
> problem on Kernel 2.6.35-7. The Device (LM3S9B90 dev kit) works correctly under
> Windows 2000. Also flashing via openocd which uses libftdi works.
> I already removed brltty (which seems to cause some trouble as I found out on
> the web).

Thanks,
Johan
