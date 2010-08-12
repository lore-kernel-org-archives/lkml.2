Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940Ab0HLMgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:36:15 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:34001 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab0HLMgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:36:14 -0400
Date: Thu, 12 Aug 2010 14:36:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Fred ." <eldmannen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fix the BKL, merge the patches
Message-ID: <20100812123612.GB31653@merkur.ravnborg.org>
References: <AANLkTimZFYTVpsugX81KTECSrz4dv4V45E1v1brhnFH7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimZFYTVpsugX81KTECSrz4dv4V45E1v1brhnFH7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 01:20:44PM +0200, Fred . wrote:
> BKL is a long standing issue with the kernel.
> 
> There are patches for it, why arent they merged?
> Merge the patches!
> 
> Fix the BKL, its about time!
> 
> http://kernelnewbies.org/BigKernelLock

It has not occurred to you that referred status is not quite up-to-date?
During this merge window a lot of BKL removal patches has been merged.

I guess LWN will followup with some sort of status on their kernel page
when the merge window has closed.

	Sam
