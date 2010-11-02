Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab0KBBGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:06:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:28590 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0KBBGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:06:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,277,1286175600"; 
   d="scan'208";a="622529890"
Date: Tue, 2 Nov 2010 09:04:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Add Kconfig option for default swappiness
Message-ID: <20101102010440.GA2684@localhost>
References: <1288548508-22070-1-git-send-email-bgamari.foss@gmail.com>
 <alpine.LNX.2.00.1011012108360.12889@swampdragon.chaosbits.net>
 <87wrowrd34.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wrowrd34.fsf@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 04:41:35PM -0400, Ben Gamari wrote:
> On Mon, 1 Nov 2010 21:09:58 +0100 (CET), Jesper Juhl <jj@chaosbits.net> wrote:
> > Perhaps this help text should mention the fact that swapiness setting can 
> > be changed at runtime (regardless of the set default) by writing to 
> > /proc/sys/vm/swappiness ???
> > 
> This definitely wouldn't hurt. I'll respin with updated help text.

Acked-by: Wu Fengguang <fengguang.wu@intel.com>
