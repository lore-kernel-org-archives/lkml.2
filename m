Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab2ISVwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:52:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2ISVwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:52:12 -0400
Date: Wed, 19 Sep 2012 23:52:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Input and HID updates for 3.7
In-Reply-To: <20120919185605.GA778@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1209192351120.22959@pobox.suse.cz>
References: <20120919185605.GA778@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2012, Henrik Rydberg wrote:

> Hi Jiri,
> 
> Please pull this tree to receive Input and HID updates for 3.7. The
> tree contains input core changes, Acked by Dmitry, which substantially
> reduces the irqsoff latency for all input devices. It also contains MT
> changes which allows further memory reduction, speedup and hardware
> support in the HID Multitouch driver. Lastly, you get the conversion
> of the bcm5974 driver to MT-B, which due to the mixed dependency of
> the tree fits better here than anywhere else.
> 
> Thanks,
> Henrik
> 
> The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab0650778d:
> 
>   Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)
> 
> are available in the git repository at:
> 
>   git://github.com/rydberg/linux.git for-next

Pulled. Thanks Henrik, thanks Dmitry.

-- 
Jiri Kosina
SUSE Labs
