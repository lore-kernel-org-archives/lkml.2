Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1JBCbK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 22:31:10 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46635 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472Ab1JBCa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 22:30:58 -0400
X-Sasl-enc: mqC5lZm8x+HFA3tTs1TxVbe/4oxNGjNf79vWa8ltWdUX 1317522657
Date: Sat, 1 Oct 2011 19:26:43 -0700
From: Greg KH <greg@kroah.com>
To: tmhikaru@gmail.com
Cc: Willy Tarreau <w@1wt.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111002022643.GA4076@kroah.com>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
 <20111001141751.GA8937@zeus>
 <20111001142848.GA27058@kroah.com>
 <20111001165659.GB18690@1wt.eu>
 <20111001171916.GA11989@zeus>
 <20111001175456.GC18690@1wt.eu>
 <20111001184044.GA13608@zeus>
 <20111001224313.GH18690@1wt.eu>
 <20111002015838.GA21725@roll>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111002015838.GA21725@roll>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 09:58:38PM -0400, tmhikaru@gmail.com wrote:
> 	Any way we could get something like this verification done for the
> 3.0.x stable kernels?  I'm currently stuck without any way known to me to
> verify that any of the patches I downloaded from kernel.org before it went
> down are actually correct.

I already sent a signed copy of the 3.0.4 patch that applies on top of
the 3.0 kernel to the linux-kernel mailing list a few days ago.

That should be fine for what you need right now, right?

greg k-h
