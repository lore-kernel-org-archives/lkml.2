Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2G0HdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 03:33:19 -0400
Received: from mail2.tridentmicro.com ([180.168.84.41]:12407 "EHLO
	mail2.trident.com.cn" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2G0HdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 03:33:17 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2012 03:33:17 EDT
From: Qipeng Zha <Qipeng_Zha@sigmadesigns.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 27 Jul 2012 15:26:37 +0800
Subject: arm interrupt handling 
Thread-Topic: arm interrupt handling 
Thread-Index: Ac1enJVCipg1VDzESgKkqJA1XhmqOwNK5L2g
Message-ID: <FF5886E7A1A0F346BD37602822BD01AA231CB282CC@cn-exh-02.CN.TRID.COM>
References: <20120705024259.26317.16000.stgit@build.warmcat.com>
 <201207101437.54877.florian@openwrt.org> <4FFC2712.9020208@warmcat.com>
In-Reply-To: <4FFC2712.9020208@warmcat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6R7XQ3d025694

Hi
When I study the interrupt handling code in 2.6.39 for omap soc, found don't clear CPSR.I to enable irq till each ISR finished.
Is this true? Or I miss something, since this will be wired that the core will not service any other irq before complete before irq handling.


Best wishes
Qipeng


-----Original Message-----
From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-kernel-bounces@lists.infradead.org] On Behalf Of "Andy Green (æ—å®‰å»¸)"
Sent: 2012å¹´7æœˆ10æ—¥ 20:59
To: Florian Fainelli
Cc: s-jan@ti.com; arnd@arndb.de; patches@linaro.org; tony@atomide.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; rostedt@goodmis.org; linux-omap@vger.kernel.org; linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4 0/4] Add ability to set defaultless network device MAC addresses to deterministic computed locally administered values

On 10/07/12 20:37, the mail apparently from Florian Fainelli included:

Hi -

> Le jeudi 05 juillet 2012 04:44:33, Andy Green a Ã©crit :
>> The following series adds some code to generate legal, locally administered
>> MAC addresses from OMAP4 CPU Die ID fuse data, and then adds a helper at
>> net/ethernet taking care of accepting device path / MAC mapping
>> registrations and running a notifier to enforce the requested MAC when the
>> matching network device turns up.
>
> This looks like something you can solve by user-space entirely. Expose the

That might seem so from a openwrt perspective, where you custom cook the 
whole userland thing per-device, but it ain't so from a generic rootfs 
perspective.

Why should Ubuntu, Fedora etc stink up their OSes with Panda-specific 
workarounds?  And Panda is not the only device with this issue.

-Andy

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
