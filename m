Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0KRJ1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:27:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561Ab0KRJ1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:27:11 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/3] PERF(kernel): Cleanup power events
Date: Thu, 18 Nov 2010 10:27:08 +0100
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Jean Pihet <jean.pihet@newoldbits.com>, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com
References: <1289498595-25806-1-git-send-email-trenn@suse.de> <201011140734.07770.trenn@suse.de> <20101118080132.GH32621@elte.hu>
In-Reply-To: <20101118080132.GH32621@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011181027.09363.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 November 2010 09:01:32 Ingo Molnar wrote:
...
> > @Ingo: If this does not go into x86/tip, but perf or whatever tree, it would
> > be great if you can ping me as soon as this stuff is in.
> 
> Mind sending the latest version which has been adjusted/fixed and all acks added?
Done.
This time with lkml excluded as there were only cleanups/fixes
due to a messed merge.

Thanks,

  Thomas
