Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab0LMJsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 04:48:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45733 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0LMJsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 04:48:53 -0500
Date: Mon, 13 Dec 2010 10:48:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, alan@lxorguk.ukuu.org.uk, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [98/223] TTY: open/hangup race fixup
Message-ID: <20101213094851.GE999@basil.fritz.box>
References: <201012131244.547034648@firstfloor.org>
 <20101212234638.61E93B27BF@basil.firstfloor.org>
 <4D05E6BB.3050108@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D05E6BB.3050108@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This and 97/223 should not be needed in 2.6.35 -- there is BKL
> protecting the race. IOW BKL removal in 2.6.36 introduced the regression
> these 2 patches fix.

Both dropped, thanks.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
