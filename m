Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0H0Owp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 10:52:45 -0400
Received: from relay1.sgi.com ([192.48.179.29]:33081 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab0H0Owm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 10:52:42 -0400
Date: Fri, 27 Aug 2010 15:52:31 +0100
From: Hedi Berriche <hedi@sgi.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
Message-ID: <20100827145231.GZ18967@zorg.emea.sgi.com>
Mail-Followup-To: Petr Tesarik <ptesarik@suse.cz>,
	linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tony Luck <tony.luck@intel.com>
References: <201008271537.35709.ptesarik@suse.cz> <201008271609.16099.ptesarik@suse.cz> <20100827143135.GY18967@zorg.emea.sgi.com> <201008271640.49542.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008271640.49542.ptesarik@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 15:40 Petr Tesarik wrote:
| On Friday 27 of August 2010 16:31:35 Hedi Berriche wrote:
|
| > That said, I'm letting my already over 36 hours run carry on chewing CPU
| > time, and see if it will eventually trip the same problem seen with 4-byte
| > ticket locks.
| 
| Hm, this doesn't sound like a viable approach. Since the siglock gets 
| initialized to 0 when a new process is started, it may never actually wrap 
| around.
| 
| I would rather attach a SystemTap probe somewhere during process fork and add 
| a bias to the siglock. That should work fine. Let me knock up the SystemTap 
| script...

That would be nice. Ta!

Cheers,
Hedi.
-- 
Hedi Berriche
Global Product Support
http://www.sgi.com/support
