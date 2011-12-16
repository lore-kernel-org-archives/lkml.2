Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab1LPIRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:17:43 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41442 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1LPIRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:17:42 -0500
Date: Fri, 16 Dec 2011 09:17:39 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 1/6] HWPOISON: clean up memory_failure() vs.
 __memory_failure()
Message-ID: <20111216081739.GB9508@aftab>
References: <cover.1323979146.git.tony.luck@intel.com>
 <ee8051a64e591cff72846f7fbde0889a7ad1cdee.1323979146.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee8051a64e591cff72846f7fbde0889a7ad1cdee.1323979146.git.tony.luck@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 10:48:12AM -0800, Tony Luck wrote:
> There is only one caller of memory_failure(), all other users call
> __memory_failure() and pass in the flags argument explicitly. The
> lone user of memory_failure() will soon need to pass flags too.
> 
> Add flags argument to the callsite in mce.c. Delete the old memory_failure()
> function, and then rename __memory_failure() without the leading "__".
> 
> Provide clearer message when action optional memory errors are ignored.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

ACK.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
