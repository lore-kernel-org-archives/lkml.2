Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1HUWNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:13:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:31887 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab1HUWN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:13:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,260,1312182000"; 
   d="scan'208";a="43624023"
From: Andi Kleen <andi@firstfloor.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [RFC PATCH v2] Resurrect Intel740 driver: i740fb
References: <201108212242.12717.linux@rainbow-software.org>
Date: Sun, 21 Aug 2011 15:13:27 -0700
In-Reply-To: <201108212242.12717.linux@rainbow-software.org> (Ondrej Zary's
	message of "Sun, 21 Aug 2011 22:42:06 +0200")
Message-ID: <m24o1ae7lk.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary <linux@rainbow-software.org> writes:
>
> The i740_calc_fifo() function formatting is nice but does not pass
> checkpatch. Making it checkpatch-compliant makes the code look ugly. How to
> make it both nice and compatible with Linux coding style?

When checkpatch.pl and sanity conflict, sanity should generally win.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
