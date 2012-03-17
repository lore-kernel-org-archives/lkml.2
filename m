Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032125Ab2CQAyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 20:54:46 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51847 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2CQAyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 20:54:44 -0400
Message-ID: <4F63E0CC.8090001@us.ibm.com>
Date: Fri, 16 Mar 2012 17:54:36 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Cesar Eduardo Barros <cesarb@cesarb.net>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Alok N Kataria <akataria@vmware.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] time: remove no_sync_cmos_clock
References: <1328990099-6428-1-git-send-email-cesarb@cesarb.net>
In-Reply-To: <1328990099-6428-1-git-send-email-cesarb@cesarb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031700-5518-0000-0000-00000303E868
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2012 11:54 AM, Cesar Eduardo Barros wrote:
> Commit 9863c90f682fba34cdc26c3437e8c00da6c83fa4 (x86, vmware: Remove
> deprecated VMI kernel support) removed the only place which set
> no_sync_cmos_clock. Since that commit, this variable is never set.
>
> Signed-off-by: Cesar Eduardo Barros<cesarb@cesarb.net>

Digging through my backlog here.
Sorry for the slow response, just wanted to let you know I've queued this.

thanks
-john

