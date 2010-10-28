Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab0J1Mio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:38:44 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:49146 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501Ab0J1Min (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:38:43 -0400
X-Greylist: delayed 1552 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Oct 2010 08:38:42 EDT
Date: Thu, 28 Oct 2010 08:12:40 -0400
From: William Thompson <wt@electro-mechanical.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: OOM help
Message-ID: <20101028121240.GA14603@electro-mechanical.com>
References: <20100915120349.GH29041@electro-mechanical.com> <20100916164231.3BC3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916164231.3BC3.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 09:39:11AM +0900, KOSAKI Motohiro wrote:
> Hi William
> 
> That said, there are two possibility.
>  1) your kernel (probably drivers) have memory leak
>  2) you are using really lots of GFP_KERNEL memory. and then, you need to switch 64bit kernel
> 
> 
> Can you please try latest kernel and try reproduce? I'm curios two point.
> 1) If latest doesn't OOM, the leak has been fixed already. 2) If the OOM occur,
> latest output more detailed information.
> 
> But, if you want asap solution, I recommend to try 64bit kernel.

I'm having the problem again.  This time, I'm using 2.6.35.4.  Would
changing from 1gb kernel/3gb user to 2gb/2gb help?  I don't believe I
actually use more than 1gb or so of user space memory anyway.

64-bit would require that I completely reinstall this system which is
definately not something I want to do.
