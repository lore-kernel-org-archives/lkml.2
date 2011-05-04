Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1EDAYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 20:24:21 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:45381 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752688Ab1EDAYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 20:24:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qTwdgRqfYYAcUiYNkBM71joX04gHXUNwyPRy03zh6HHTrxctZpvxjelN5CFW6+ZoHYrCnSP66aSLg+6DtaCWnoCwPNx7Sy3hssWdW9NLPTCMiTBbmSrhSsG000A/Nsmt;
Date: Tue, 3 May 2011 17:24:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Panic in input handling
Message-ID: <20110503172414.7a8872e0@jbarnes-desktop>
In-Reply-To: <20110501165245.GB23240@core.coreip.homeip.net>
References: <20110429102343.5ee9e34c@jbarnes-desktop>
	<20110501165245.GB23240@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 May 2011 09:52:45 -0700
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Fri, Apr 29, 2011 at 10:23:43AM -0700, Jesse Barnes wrote:
> > Just booted up a relatively fresh kernel and hit this when trying to
> > shut down X; maybe it's been fixed already?  I'd be happy to try any
> > patches...
> > 
> 
> Hmm, haven't seen this one yet and that part of code did not change for
> a while. Is it reproducible?

No, I've only seen it once.  It could very well have been due to some
other memory corruption...

-- 
Jesse Barnes, Intel Open Source Technology Center
