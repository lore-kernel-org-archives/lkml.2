Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab0F1Qd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:33:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59738 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab0F1Qd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TIkS7JRp1H6otKsSJ2QlrGmYfm9a/cPLUCEjpo16R1t/ONAnVOd96+7ivJleVwclTF
         PMHvDHiBKL9DkocsxnDW9sGyY5ayBCHXmXp4YdALUPsGOMU+EXsQvsbCphsCDSvyaqWs
         DEwrcwLiZLiRKCNpb/wuX5/BSGK6jMipOQBBw=
Date: Mon, 28 Jun 2010 09:33:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression: ps2mouse not working in 2.6.34
Message-ID: <20100628163350.GA11670@core.coreip.homeip.net>
References: <4C28C81E.4010909@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C28C81E.4010909@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 12:04:46PM -0400, Mark Lord wrote:
> Okay, who broke it, and how do I re-enable it?
> 
> The PS/2 mice on my systems here don't do anything with 2.6.34.
> One system complains that I need to boot with i8042.nopnp to enable it,
> which I also tried, but still nogo.  Same behaviour with or without
> /dev/psaux enabled.  64-bit kernel.
> 
> The other system, running older userspace, hangs at the X-server startup
> because it cannot find the mouse.  No i8042 warnings.   32-bit kernel.
> 
> Both systems working fine with older kernels.
> Google finds lots of other people discovering the same problem.
> 
> What gives?
> 

Well, lest start small: did it work ifor you with 2.6.33? Does kernel
discover AUX serio port (dmesg)? What about the mouse itself? Is it
absent or is it not reporting events?

Thanks.

-- 
Dmitry
