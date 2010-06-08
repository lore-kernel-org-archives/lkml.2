Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab0FHVx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:53:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49807 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751385Ab0FHVx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:53:56 -0400
Date: Tue, 8 Jun 2010 22:56:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Yuhong Bao <yuhongbao_386@hotmail.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: Windows side agrees that lowmem corruption is a problem too
Message-ID: <20100608225656.7f645621@lxorguk.ukuu.org.uk>
In-Reply-To: <201006082122.25089.linux@rainbow-software.org>
References: <SNT125-W34B02C6BF1C272DC47AF7DC3D60@phx.gbl>
	<4C0E949D.6090002@zytor.com>
	<20100608190848.GD25985@elte.hu>
	<201006082122.25089.linux@rainbow-software.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I agree that dis-using <1M by default is probably the sanest option.
> 
> But please limit it to newer systems only (DMI present && year > 200?). There 
> are many old machines running fine. Losing 1MB from 16MB is a bad thing.

Losing the low 1MB is bad thing anyway for things like firmware flashing
and other weird crap that needs low pages (floppy controllers etc).

Losing 64K (but reporting corruption in it in a big scary way) is
probably sensible for distributions, but its a config item so its policy
so that wouldn't be a problem.

It has to be painful to the vendors so they get complaints, reports and
support call costs. Otherwise they won't have the correct incentives to
fix their mess.

Alan
