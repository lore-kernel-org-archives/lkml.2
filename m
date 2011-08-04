Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1HDOkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:40:31 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45238 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856Ab1HDOka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:40:30 -0400
X-Sasl-enc: Lq+xXTdn00icGcCzR6jTRVvXgNjPQE8Z0QqKL0v4wyQ0 1312468828
Date: Thu, 4 Aug 2011 07:36:42 -0700
From: Greg KH <greg@kroah.com>
To: "MRU.Ilya" <utdilya@mail.ru>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: pty.c  in linux 2.6.31-rc5+
Message-ID: <20110804143642.GB18468@kroah.com>
References: <4E3A3F87.3050204@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3A3F87.3050204@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 10:43:19AM +0400, MRU.Ilya wrote:
> Synchronic's line disciplines(ppp_synctty, hdlc) can't work with
> pseudo terminals.
> 
> If frames send very fast from one side(master/slave) to other one,
> frames merge in one (merge point "flip buffer") and the other side
> can read only one big frame.
> But sync line discipline need one frame in one read.
> 
> For push one frame to ldisc I propose small patch, but this regression for
> commit e043e42bdb66885b3ac10d27a01ccb9972e2b0a3.
> 
> I don't find any mutexes and other things forbidden in not user context,
> in function flush_to_ldisc() , and I think this patch
> is true and this function can called from any context. But I not sure.
> 
> Relative commit  86d23a057e718f73adc15e463c643d6e014a19cd.

I don't see a patch here.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
