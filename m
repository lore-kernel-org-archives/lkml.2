Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab2EUJ2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:28:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34012 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab2EUJ2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:28:02 -0400
Message-ID: <4FBA0A9A.8040901@linaro.org>
Date: Mon, 21 May 2012 17:27:54 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: Richard Zhao <richard.zhao@freescale.com>, sameo@linux.intel.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        Richard Zhao <richard.zhao@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] mfd: anatop: permit adata be NULL when access register
References: <1336870794-6351-1-git-send-email-richard.zhao@freescale.com> <1336870794-6351-2-git-send-email-richard.zhao@freescale.com> <20120514035137.GB20367@S2100-06.ap.freescale.net> <20120514080835.GB31985@opensource.wolfsonmicro.com> <4FB0C9D4.2060409@linaro.org> <20120514094357.GF20367@S2100-06.ap.freescale.net> <4FB10821.4000004@linaro.org> <20120514135035.GC29393@b20223-02.ap.freescale.net> <20120518095932.GI30755@b20223-02.ap.freescale.net> <20120521041355.GF5810@S2100-06.ap.freescale.net>
In-Reply-To: <20120521041355.GF5810@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012年05月21日 12:13), Shawn Guo wrote:
> On Fri, May 18, 2012 at 05:59:32PM +0800, Richard Zhao wrote:
>> Guys, we need to draw conclusion.
>> I think current patch keep some how compatible with multi-anatop.
>> It's ok.
>>
> I'm fine with that.
> 
Yes. It is good for me.
