Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab2CaLGo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 07:06:44 -0400
Received: from aldebaran.gro-tsen.net ([88.191.60.176]:42041 "EHLO
	aldebaran.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab2CaLGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 07:06:42 -0400
Date: Sat, 31 Mar 2012 13:06:40 +0200
From: David Madore <david+ml@madore.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: since when does linkat() on deleted /proc/$PID/fd/$num return
 ENOENT ?
Message-ID: <20120331110640.GA18532@aldebaran.gro-tsen.net>
References: <20120330102121.GA5999@aldebaran.gro-tsen.net>
 <20120331065305.GA3398@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120331065305.GA3398@p183.telecom.by>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 09:53:05AM +0300, Alexey Dobriyan wrote:
> It was explicitly prohibited since 2.6.39:
> 
> commit aae8a97d3ec30788790d1720b71d76fd8eb44b73
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Sat Jan 29 18:43:27 2011 +0530
> 
>     fs: Don't allow to create hardlink for deleted file
<snip>

Thanks for digging this for me!

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
