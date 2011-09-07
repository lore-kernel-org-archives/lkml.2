Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1IGRJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:09:14 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38439 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab1IGRJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:09:10 -0400
Date: Wed, 7 Sep 2011 11:23:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 4/5] mce: remove TIF_MCE_NOTIFY
Message-ID: <20110907092327.GC7725@aftab>
References: <4e5eb3f12101199595@agluck-desktop.sc.intel.com>
 <4e5eb4fd21057689fc@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5eb4fd21057689fc@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 06:26:05PM -0400, Luck, Tony wrote:
> From: Tony Luck <tony.luck@intel.com>
> 
> Hidetoshi Seto has re-worked the notification code to use a
> worker thread for propagating notifications. So TIF_MCE_NOTIFY
> is unused. Previous plans to use this to somehow switch from
> "machine check context" to a more friendly environment to
> deal with immediate errors look like they will never pan out.

Err, I don't get it: patch 1/5 says:

"So keep the [TIF_MCE_NOTIFY] flag for such possible future use, until
better mechanism is introduced."

and here you remove it. AFAIR, last time we agreed on the irq_work ->
realtime recovery thread approach so why not drop this flag in patch 1/5
and forget this one.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
