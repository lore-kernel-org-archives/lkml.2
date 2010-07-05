Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0GEH2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 03:28:06 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:41158 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab0GEH2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 03:28:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: macbook webcam no longer works on .35-rc
Date: Mon, 5 Jul 2010 09:28:46 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.3; x86_64; ; )
Cc: linux-media@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1277932269.11050.1.camel@jlt3.sipsolutions.net> <1278055575.3737.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1278055575.3737.7.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007050928.46888.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On Friday 02 July 2010 09:26:15 Johannes Berg wrote:
> On Wed, 2010-06-30 at 23:11 +0200, Johannes Berg wrote:
> > I'm pretty sure this was a regression in .34, but haven't checked right
> > now, can bisect when I find time but wanted to inquire first if somebody
> > had ideas. All I get is:
> > 
> > [57372.078968] uvcvideo: Failed to query (130) UVC control 5 (unit 3) :
> > -32 (exp. 1).

Does it prevent your camera from working, or does it "just" print annoying 
messages to the kernel log ?

-- 
Regards,

Laurent Pinchart
