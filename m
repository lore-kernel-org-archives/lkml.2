Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1BFRFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 12:05:00 -0500
Received: from lobo.ruivo.org ([173.14.175.98]:58580 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab1BFRE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 12:04:59 -0500
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Feb 2011 12:04:59 EST
Date: Sun, 6 Feb 2011 11:55:24 -0500
From: Aristeu Rozanski <aris@cathedrallabs.org>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uinput strnlen bugfix
Message-ID: <20110206165524.GG22170@cathedrallabs.org>
References: <AANLkTi=vBv_a+X3MrgyDevss9H92vBJ51eON_qyMJW4=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=vBv_a+X3MrgyDevss9H92vBJ51eON_qyMJW4=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 05:49:23PM +0100, David Herrmann wrote:
> The uinput device driver (drivers/input/misc/uinput.c) incorrectly
> computes the size of new device names. This patch fixes this. The diff
> is against 2.6.37 but the bug also exists in the most recent git
> sources.
> 
> strnlen() never returns negative numbers so the result should be
> incremented after checking for zero. Otherwise the test will always be
> false. This bug allows empty input device names.
> 
> Please CC me, I'm not subscribed to the mailing list.
and where's the patch? :^)

-- 
Aristeu

