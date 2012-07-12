Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162692Ab2GLXRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:17:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162577Ab2GLXEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:04:16 -0400
Date: Thu, 12 Jul 2012 16:04:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, lenb@kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
        Donggeun Kim <dg77.kim@samsung.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        SangWook Ju <sw.ju@samsung.com>, Durgadoss <durgadoss.r@intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [RESEND PATCH v4 1/5] thermal: add generic cpufreq cooling
 implementation
Message-Id: <20120712160415.473748fd.akpm@linux-foundation.org>
In-Reply-To: <1342100468-19426-2-git-send-email-amit.kachhap@linaro.org>
References: <1342100468-19426-1-git-send-email-amit.kachhap@linaro.org>
	<1342100468-19426-2-git-send-email-amit.kachhap@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 19:11:04 +0530
Amit Daniel Kachhap <amit.kachhap@linaro.org> wrote:

> [akpm@linux-foundation.org: fix comment layout]
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
> Cc: Donggeun Kim <dg77.kim@samsung.com>
> Cc: Guenter Roeck <guenter.roeck@ericsson.com>
> Cc: SangWook Ju <sw.ju@samsung.com>
> Cc: Durgadoss <durgadoss.r@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Something strange appears to have happened here?  At a guess it seems
that the patches were in my tree, I sent them to someone (Len?), then
they were merged into linux-next by "someone" and then they fell
out of linux-next again?

If so, they will hopefully come back soon.  If not, something failed
fairly seriously.


I took a look at re-merging these patches into my tree, but there are
significant conflicts with other work which has gone into linux-next.

