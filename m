Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab0IXPHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 11:07:19 -0400
Received: from xenotime.net ([72.52.115.56]:52344 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751651Ab0IXPHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 11:07:18 -0400
Date: Fri, 24 Sep 2010 08:07:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Any SYSRQ key to force mode switch to console mode when using
 KMS?
Message-Id: <20100924080707.ba98fa1e.rdunlap@xenotime.net>
In-Reply-To: <19611.32996.817920.499437@elektron.ikp.physik.tu-darmstadt.de>
References: <19601.1301.803816.92851@elektron.ikp.physik.tu-darmstadt.de>
	<20100921151033.80e61747.randy.dunlap@oracle.com>
	<19609.53242.674915.369484@elektron.ikp.physik.tu-darmstadt.de>
	<4C9A1FB7.9050902@oracle.com>
	<19611.8986.142128.168878@elektron.ikp.physik.tu-darmstadt.de>
	<19611.20403.865248.695829@elektron.ikp.physik.tu-darmstadt.de>
	<20100923080212.ca4be1f6.rdunlap@xenotime.net>
	<19611.32996.817920.499437@elektron.ikp.physik.tu-darmstadt.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 18:31:32 +0200 Uwe Bonnes wrote:

[just adding cc's]

> >>>>> "Randy" == Randy Dunlap <rdunlap@xenotime.net> writes:
> 
> 
>     Randy> Is CONFIG_DRM_KMS_HELPER enabled in your kernel .config file?  If
>     Randy> not, we need to find out how to enable it (there is no kconfig
>     Randy> prompt for it).
> 
> Yes, it is enabled
> 
>     Randy> Can you check if Alt-Sysrq-H (help) lists V for "force-fb(V)"?
> Yes, it is listed.
> 
> And yes, my last experiments where with ALT-CTL-sysreq, so doomed for non
> function due to operator error.
> 
> However:
> When running X, X.Org X Server 1.9.0 on Thinkpad R50 RV250, Alt-Sysrq-v
> switches to an all-black display. By console switching with ALT-CLT-F1 I
> get back to the booting console and ALT-CLT-F7 brings me back to X.  Running
> on the console and calling Alt-Sysrq-v prints
>  SysRq : Restore framebuffer console
> 
> Is there some omission by the distribution or my setup that Alt-Sysrq-v when
> running X results in an all-black screen?
> 
> And when I hit the hibernate problem, the screen stays black even with a
> console switch after Alt-Sysrq-v
> 
> Bye
> -- 
> Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de
> 
> Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
> --------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
