Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1HALJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:09:59 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:33595 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1HALJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:09:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sven Eckelmann <sven@narfation.org>
Subject: Re: [PATCHv4 05/11] omap3isp: Use *_dec_not_zero instead of *_add_unless
Date: Mon, 1 Aug 2011 13:10:02 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1311760070-21532-1-git-send-email-sven@narfation.org> <201107311700.43515.laurent.pinchart@ideasonboard.com> <1518031.UNu44UiQdf@sven-laptop.home.narfation.org>
In-Reply-To: <1518031.UNu44UiQdf@sven-laptop.home.narfation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108011310.02626.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sven,

On Monday 01 August 2011 12:07:15 Sven Eckelmann wrote:
> On Sunday 31 July 2011 17:00:43 Laurent Pinchart wrote:
> > On Wednesday 27 July 2011 11:47:44 Sven Eckelmann wrote:
> > > atomic_dec_not_zero is defined for each architecture through
> > > <linux/atomic.h> to provide the functionality of
> > > atomic_add_unless(x, -1, 0).
> > > 
> > > Signed-off-by: Sven Eckelmann <sven@narfation.org>
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > I'll queue this to my tree for v3.2. Please let me know if you would
> > rather push the patch through another tree.
> 
> The problem is that until now no one from linux-arch has applied the patch
> 01/11 in his tree (which is needed before this patch can be applied) and
> you tree have to be based on the "yet to be chosen linux-arch tree".
> Otherwise your tree will just break and not be acceptable for a pull
> request.
> 
> Maybe it is easier when one person applies 01-11 after 02-11 was Acked-by
> the responsible maintainers.
> 
> 02 is more or less automatically Acked-by us :)
> 04, 09 and 10 are also Acked.
> ... and the rest is waiting for actions.

OK. I'm fine with 05/11 being pushed through any tree with my ack. Please let 
me know if/when you want me to apply it to my tree.

-- 
Regards,

Laurent Pinchart
