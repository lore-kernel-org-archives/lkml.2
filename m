Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab2ACKfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 05:35:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab2ACKfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 05:35:20 -0500
Date: Tue, 3 Jan 2012 11:34:58 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 didn't survive after s2ram failure
Message-ID: <20120103103457.GA3391@redhat.com>
References: <20111227105340.GD5344@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111227105340.GD5344@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 11:53:40AM +0100, Michal Hocko wrote:
> my laptop died (due to drained batteries) while it was suspended to
> RAM and the wireless didn't get back to life after I booted again.

I wonder how we could kill hardware that way ...

> Dmesg says:
> cfg80211: Calling CRDA to update world regulatory domain
> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
> iwl3945: Copyright(c) 2003-2011 Intel Corporation
> iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> iwl3945 0000:05:00.0: setting latency timer to 64
> iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> iwl3945 0000:05:00.0: bad EEPROM signature,EEPROM_GP=0x00000007
> iwl3945 0000:05:00.0: EEPROM not found, EEPROM_GP=0xffffffff
> iwl3945 0000:05:00.0: Unable to init EEPROM
> iwl3945 0000:05:00.0: PCI INT A disabled
> iwl3945: probe of 0000:05:00.0 failed with error -2
> 
> Is there anything I can do to resurrect it?

No idea. Please provide logs with debug=0x47ffffff option.

Did you try to totally power-off the laptop by removing
battery (and power cable of course) ?

If anything other will not help, is possible to rewrite eeprom, I don't
know how to do this, but I know that tool for that exist:
http://code.google.com/p/iwleeprom/

Stanislaw
