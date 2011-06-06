Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1FFGA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 02:00:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54962 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1FFGAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 02:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q2bIDouIBFJtCX6GyfbpEusodpUoPUKbU8A1+9NxSxow4LyU0ECi0ucOx+TEu73B2i
         VT+wNW1EOt9TGqeDu1ACh5FP/YtIEvo3HjcfyCmTH91nVbEKVdXa9IYx+oq5Cc76aaAY
         2ecjCJvr2IN+jjncImzhNLLxY58bSiPfOu/NQ=
Date: Mon, 6 Jun 2011 09:00:12 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Subject: Re: [PATCH 4/5] staging: et131x: et131x_initpci.c checkpatch fixes
Message-ID: <20110606060012.GB3846@shale.localdomain>
References: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
 <1307295320-31716-5-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307295320-31716-5-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 06:35:19PM +0100, Mark Einon wrote:
> -	/* Setup the fundamental net_device and private adapter structure elements  */
> +	/* Setup the fundamental net_device and private adapter structure
> +	 * elements  */

This isn't the normal multi-line comment style.  I don't care, but
for next time.

regards,
dan carpenter
