Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab2CTXF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:05:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50171 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759159Ab2CTXFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:05:55 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH v8 0/8] Consolidate cpuidle functionality
Date: Tue, 20 Mar 2012 23:05:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Robert Lee <rob.lee@linaro.org>, len.brown@intel.com,
        akpm@linux-foundation.org, rjw@sisk.pl, robherring2@gmail.com,
        Baohua.Song@csr.com, amit.kucheria@linaro.org, nicolas.ferre@atmel.com,
        linux@maxim.org.za, kgene.kim@samsung.com, amit.kachhap@linaro.org,
        magnus.damm@gmail.com, nsekhar@ti.com, daniel.lezcano@linaro.org,
        mturquette@linaro.org, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        deepthi@linux.vnet.ibm.com, broonie@opensource.wolfsonmicro.com,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk,
        jean.pihet@newoldbits.com, venki@google.com, ccross@google.com,
        g.trinabh@gmail.com, kernel@wantstofly.org, lethal@linux-sh.org,
        jon-hunter@ti.com, tony@atomide.com, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pm@vger.kernel.org
References: <1332274969-15782-1-git-send-email-rob.lee@linaro.org> <201203202158.08042.arnd.bergmann@linaro.org> <873992zy5u.fsf@ti.com>
In-Reply-To: <873992zy5u.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203202305.37952.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:cpfK2F2Ne1NiVGpR6iSaKzrqc2dVuzcvX+oRDjxDWzv
 9mW48wjADs2a8HGy0v1n5Tmm90h6E3ugX8vvyfL7ZI4e7hMY9o
 1D1PRbCCMk20725RBgGC098aO0oYDUPZayhoyinWPE1jA12dRX
 qXYInEvEIkfw1gSNv1BuTWS05sb/YAOHN2K8f+ySourDOj6muR
 W/7DJHE5gmPcfHHdHVjZ9Ed1P7IHbT5hY4+bZSKOOwQP6Q6PrP
 TYtvtqiVP7dPPUGCjvZ8TOu/vPSK6hMQeROhC+QbDknEEztjNk
 g9jS9q6+X6UF5iAkMftrgbThDxZfXsW3scUVEXedrV4xL/4gDT
 4HEdgSHrMhgi4TPjRf5ownL/oCQQGLufI0R0UcjJg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2012, Kevin Hilman wrote:
> Maybe it's time that drivers/cpuidle gets a maintainer.  With lots of
> discussions of scheduler changes that affect load estimation, I suspect
> we're all going to have a bit of CPUidle work to do in the
> not-so-distant future.

Hmm, according to the script, you are the maintainer ;-)

$ scripts/get_maintainer.pl -f drivers/cpuidle/cpuidle.c
Kevin Hilman <khilman@ti.com> (commit_signer:8/10=80%)
Len Brown <len.brown@intel.com> (commit_signer:7/10=70%)
Trinabh Gupta <g.trinabh@gmail.com> (commit_signer:4/10=40%)
Arjan van de Ven <arjan@linux.intel.com> (commit_signer:4/10=40%)
Deepthi Dharwar <deepthi@linux.vnet.ibm.com> (commit_signer:4/10=40%)

While I realize that the get_maintainers.pl is not the final word,
you could be the acting cpuidle maintainer for this merge window
and send the pull request.

	Arnd
