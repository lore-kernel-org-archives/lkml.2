Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982Ab2JXHen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:34:43 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:41317 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934396Ab2JXHem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:34:42 -0400
Date: Wed, 24 Oct 2012 09:34:39 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH 010/193] arch/cris/arch-v32/drivers: remove
 CONFIG_EXPERIMENTAL
Message-ID: <20121024073438.GA29793@axis.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-11-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-11-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:01:23PM +0200, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.

> CC: Mikael Starvik <starvik@axis.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
