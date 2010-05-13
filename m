Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab0EMQbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:31:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:20230 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab0EMQbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:31:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,223,1272870000"; 
   d="scan'208";a="566886453"
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
From: reinette chatre <reinette.chatre@intel.com>
To: Nils Radtke <lkml@Think-Future.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100513113257.GA7535@localhost>
References: <20100513113257.GA7535@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 09:31:09 -0700
Message-ID: <1273768269.2295.1144.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 04:32 -0700, Nils Radtke wrote:
>   short feedback:
> 
>   - recompiled kernel and config80211 as M
>   - debug symbols included. Yet to try.
>   - reboot
>     Linux mypole 2.6.33.3 #22 SMP PREEMPT Thu May 13 12:52:22 CEST 2010 i686 GNU/Linux
>   - renamed in-tree iwlagn and iwlcore, ran depmod -a, confirmed by looking into modules.dep

Note that compat-wireless installs its modules in updates/ and thus does
not overwrite your default ones. After default modules are unloaded the
ones in updates/ should be picked up first. No renaming or overwriting
of system's default modules should be done.

Following the instructions that come with compat-wireless should be all
you need to do.

Reinette


