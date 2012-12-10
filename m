Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab2LJWVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:21:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49313 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2LJWVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:21:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 2/3] dmaengine: dw_dmac: Enhance device tree support
Date: Mon, 10 Dec 2012 22:21:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Viresh Kumar <viresh.kumar@linaro.org>, vinod.koul@intel.com,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, andriy.shevchenko@linux.intel.com
References: <3100e691db3f94c22afd98b609a1568d7e70dfe7.1350360935.git.viresh.kumar@linaro.org> <169edae67b9a051ca7448e5b62c3cd2c5c1db470.1350360935.git.viresh.kumar@linaro.org> <201212102208.52347.arnd@arndb.de>
In-Reply-To: <201212102208.52347.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212102221.06614.arnd@arndb.de>
X-Provags-ID: V02:K0:HPl2uzHiapTtHOBYDoKiVryhMPAZzmvgSYcTM6QVZfK
 TnQkn0Y4Iib15KuR47PQujtCm9Q/bR6r/LgrnONAicF0MQYxBv
 CEBxCX/J3NM5BhiHebHj/JrxHtzS4KyoDtOZZUsfJnnEKTjnUm
 wHdeEoLsKG+pQjmElEw7ePuH0nllSaWiZro92S6e6o3SiWO4FL
 iuL3qVPp8sRhImHlqgrCZI0oRH8AEUnAvvzmAw9bWiC67vBLp7
 d1dPZIqo5C1eGCIyAkXTbwVI6hjUIh/1Wjnf31JjW6GSqU1PYd
 nvYBDaMsfgTh+pvDDbgfmoP6B+A0qcIyGc1Qt4ewsPp3YNeB6g
 SGNCEs4P+sL4XsEAydKM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2012, Arnd Bergmann wrote:
> The build bug is not the problem however, but the abuse of the
> API is. Andy, are you sure you understood what this does when
> you gave you Reviewed-by comment?
> 

Ah, I just saw that Andy had the right intuition when commenting on
it at first, but Viresh managed to convince him otherwise, and appearently
neither had followed the discussion about the dmaengine bindings...

	Arnd
