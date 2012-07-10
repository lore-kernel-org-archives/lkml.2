Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2GJNIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 09:08:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17578 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab2GJNIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 09:08:51 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=u_GZ6iskD1YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=o0Ty9n8eIuSAu_UYb-kA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1341925729.14828.17.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4 0/4] Add ability to set defaultless network device MAC
 addresses to deterministic computed locally administered values
From: Steven Rostedt <rostedt@goodmis.org>
To: "\"Andy Green" =?UTF-8?Q?=28=E6=9E=97=E5=AE=89=E5=BB=B8=29=22?= 
	<andy@warmcat.com>
Cc: Florian Fainelli <florian@openwrt.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        s-jan@ti.com, arnd@arndb.de, patches@linaro.org, tony@atomide.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Jul 2012 09:08:49 -0400
In-Reply-To: <4FFC2712.9020208@warmcat.com>
References: <20120705024259.26317.16000.stgit@build.warmcat.com>
	 <201207101437.54877.florian@openwrt.org> <4FFC2712.9020208@warmcat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 20:58 +0800, "Andy Green (林安廸)" wrote:
> On 10/07/12 20:37, the mail apparently from Florian Fainelli included:
> 

> Why should Ubuntu, Fedora etc stink up their OSes with Panda-specific 
> workarounds?  And Panda is not the only device with this issue.

Actually I think you just answered your own question ;-)

Anyway, I don't think an initrd solution is the best. Yeah, it's fine
for a work around, but then I need to go and screw with the initrd if it
doesn't have support for the board. If the network card already has a
MAC address, why should the kernel give it another *random* one?

This isn't a complex patch set, where the complexity should be put into
userspace. And it makes it very convenient for people that just want the
board to boot so they can test it. I'm not developing any SoC or BSP,
I'm just using it to make sure my kernel changes can also be implemented
for ARM.

-- Steve


