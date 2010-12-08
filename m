Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0LHXGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:06:11 -0500
Received: from kroah.org ([198.145.64.141]:36689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661Ab0LHXGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:06:10 -0500
Date: Wed, 8 Dec 2010 15:06:01 -0800
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, lkml20101129@newton.leun.net,
        netdev@vger.kernel.org, jesse@nicira.com, linux-kernel@vger.kernel.org,
        greearb@candelatech.com, stable@kernel.org
Subject: Re: [stable] [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when
 vid not used
Message-ID: <20101208230601.GB8062@kroah.com>
References: <1291108809.2904.3.camel@edumazet-laptop>
 <20101201111716.424fb771@xenia.leun.net>
 <1291200914.2856.546.camel@edumazet-laptop>
 <20101208.084731.189716071.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208.084731.189716071.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 08:47:31AM -0800, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Wed, 01 Dec 2010 11:55:14 +0100
> 
> 
> Greg/-stable, please integrate this patch from Eric into 2.6.36 if you
> haven't already done so.

It looks like I took a different, older version, I'll update it to this
one now.

thanks,

greg k-h
