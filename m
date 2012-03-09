Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab2CIS2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:28:54 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:40581 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758431Ab2CIS2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:28:53 -0500
Date: Fri, 9 Mar 2012 10:28:46 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, sfr@ozlabs.org,
        yinghai@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.3.0-rc6-next-20120308 boot failure on POWER7 blade
Message-ID: <20120309102846.51f0df89@jbarnes-x220>
In-Reply-To: <20120309144645.5b5997d2@kryten>
References: <20120309142555.7ec5e0ac@kryten>
	<1331263785.3105.52.camel@pasglop>
	<20120309144645.5b5997d2@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 174.253.221.157 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012 14:46:45 +1100
Anton Blanchard <anton@samba.org> wrote:

> 
> Hi Ben,
> 
> > Looks like something that got fixed but the new patches from Bjorn
> > aren't in next yet. I'll fwd you the patch separately to apply on
> > top of what you have see if that helps (to confirm that's indeed the
> > issue).
> 
> Thanks, confirmed that it fixes it. Patch below in case anyone else is
> hitting it.
> 
> Anton
> 
> --
> 
> On Sat, 2012-03-03 at 08:52 +1100, Benjamin Herrenschmidt wrote:
> 
> > Or give me a chance to dig :-) I'll have a look next week.
> 
> This is indeed what bjorn suspected on irc, this patch fixes it:
> 
> (Bjorn, please fold it in the original offending patch)

Thanks guys; I'll push the fixes to -next when I get to a real network
(at the airport now about to run out of battery with a crappy
connection).

Jesse
