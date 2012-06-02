Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980Ab2FBFu4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 01:50:56 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57167 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784Ab2FBFuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 01:50:54 -0400
Message-ID: <4FC9A9BA.1020904@kernel.org>
Date: Sat, 02 Jun 2012 01:50:50 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: Kevin Hilman <khilman@ti.com>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        linux-pm@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [linux-pm] [PATCH 0/2] bug fixes for coupled cpuidle
References: <1337364324-12171-1-git-send-email-ccross@android.com>
In-Reply-To: <1337364324-12171-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 02:05 PM, Colin Cross wrote:

> The last modifications made to the coupled cpuidle patches introduced
> two bugs that I missed during testing.  The online count was never
> initialized, causing coupled idle to always wait and never enter the
> ready loop.  That hid the second bug, the ready count could never be
> decremented after exiting idle.
> 
> Len, these two patches could be squashed into patch 3 of the original
> set.  If you do squash them, you could also add Rafael's tags to the
> set (Reviewed-by on 1 and 2, acked-by on 3).


squash & tags update done.

> Or I can reupload the
> whole stack as v5 if you prefer.


no need.

thanks,
-Len Brown, Intel Open Source Technology Center
