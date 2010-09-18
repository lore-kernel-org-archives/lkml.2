Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab0IRACl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 20:02:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36262 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0IRACk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 20:02:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XX2ySEfVMrvrXTH0lrvL+h5Rd3RskAseJhcxaz2f/EBFim/8YFvUtXPbmNcdLBjo0U
         wIY3IroUSDdkrGAGpmMNAT+Pc3wdTih48Q/2pgVQFgrKk+VPjKtuKF8YSIWKNFeKomZA
         Yhy8xkQVZOzsbISXRvxMUj+7AIkzInKeJYYDk=
Subject: Re: [git pull] FireWire fixes
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Peter Stuge <peter@stuge.se>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux1394-devel@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100918000024.4334.qmail@stuge.se>
References: <tkrat.b186ea3830d71c45@s5r6.in-berlin.de>
	 <1284764773.2804.7.camel@maxim-laptop> <4C93FCC7.9040406@s5r6.in-berlin.de>
	 <20100918000024.4334.qmail@stuge.se>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Sep 2010 02:02:33 +0200
Message-ID: <1284768153.2741.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-18 at 02:00 +0200, Peter Stuge wrote: 
> Stefan Richter wrote:
> > > Cable disconection/reconnection still results in the link loss till
> > > ifconfig down/up.
> > 
> > Surely a higher-level problem somewhere in firewire-net.
> 
> How to deal with cable glitch? The cable might as well never be
> attached again. A timeout? How long? There's a timeout also in SBP-2 IIRC?
Not that.
I mean I expect that if I plug the cable in, I expect the interface to
start working right away, without need of ifconfig up/down as is the
case with ethernet.
(assuming that I did set the IP of the interface beforehand).

Best regards,
Maxim Levitsky

