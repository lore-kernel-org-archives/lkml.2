Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab2KUFQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:16:37 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:53254 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2KUFQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:16:36 -0500
Date: Wed, 21 Nov 2012 14:16:33 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: Re: [PATCH 11/42] ARM: shmobile: Register PFC platform device
Message-ID: <20121121051633.GF6570@verge.net.au>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1353464863-10281-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353464863-10281-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 03:27:12AM +0100, Laurent Pinchart wrote:
> Add arch code to register the PFC platform device instead of calling the
> driver directly. Platform device registration in the sh-pfc driver will
> be removed.

I'm not really sure that I understand the motivation for
moving platform device registration from the driver into
mach-shmobile. Could you explain this a little?
