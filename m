Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1CQSSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:18:02 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63410 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab1CQSSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:18:00 -0400
Date: Thu, 17 Mar 2011 12:17:57 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ed W <lists@wildgooses.com>
Cc: Andres Salomon <dilinger@queued.net>, rpurdie@rpsys.net,
        linux-geode@lists.infradead.org, const@mimas.ru,
        linux-kernel@vger.kernel.org
Subject: Re: Feedback please: [PATCH] leds: New PCEngines Alix LED driver
 using gpio interface
Message-ID: <20110317181757.GM9597@angua.secretlab.ca>
References: <4D81D7FD.1040602@wildgooses.com>
 <20110317084328.41831b4c@debxo>
 <AANLkTikga=zrNgfsuN4=8tCfZz0n7vkk6i0xW-zj6zSD@mail.gmail.com>
 <4D8243E7.7030309@wildgooses.com>
 <20110317105210.420e55c4@queued.net>
 <4D824BEA.70502@wildgooses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D824BEA.70502@wildgooses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 05:59:06PM +0000, Ed W wrote:
> On 17/03/2011 17:52, Andres Salomon wrote:
> > OLPC stuff lives in arch/x86/platform/olpc; if there was more
> > alix-specific stuff, I'd suggest moving it into something similar.
> > However, I didn't find any.  Maybe an arch/x86/platform/geode as a
> > place to collect platform drivers for the various geode-based machines
> > out there (alix, soekris, etc)?  Though honestly, I'm not that
> > interested in doing the work to migrate stuff over to there.
> 
> 
> As this is my first stab at this, I think you are agreeing that the
> current change is ok as a first step at least?  (I can have a go at a
> larger code re-org later...)

It is actually really easy.  You just need to move the file into
arch/x86/platform/geode, add a Makefile, and add a line to
arch/x86/platform/Makefile to include it.  In this particular case,
since so much code is sliced out, the patch will actually be easier to
review if the file is moved at the same time.

g.
