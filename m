Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2HSJMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 05:12:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34777 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2HSJMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 05:12:30 -0400
Date: Sun, 19 Aug 2012 12:12:26 +0300
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH 1/2] vsmp: Use hypervisor layer for initialization
Message-ID: <20120819091226.GA18930@WorkStation.localnet>
References: <1344445299-22142-1-git-send-email-ido@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344445299-22142-1-git-send-email-ido@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 08:01:38PM +0300, Ido Yariv wrote:
> vSMP Foundation detection and initialization could be done by the
> hypervisor layer, so set it up that way.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> Acked-by: Shai Fultheim <shai@scalemp.com>
> ---

Ping?

Thanks,
Ido.
