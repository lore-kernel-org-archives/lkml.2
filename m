Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3AJMTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:19:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36187 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab3AJMTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:19:35 -0500
Message-ID: <50EEB1C1.9060306@ti.com>
Date: Thu, 10 Jan 2013 17:49:13 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kumar, Anil" <anilkumar.v@ti.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>, "hs@denx.de" <hs@denx.de>
Subject: Re: [PATCH V2 3/3] ARM: davinci: da850: add NAND driver entries
References: <1357633220-29827-1-git-send-email-anilkumar.v@ti.com> <1357633220-29827-4-git-send-email-anilkumar.v@ti.com> <50ED66F2.8050006@ti.com> <F3DBB1B3EF102E4994C89758CFCA32412B80CA@DBDE01.ent.ti.com>
In-Reply-To: <F3DBB1B3EF102E4994C89758CFCA32412B80CA@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2013 1:07 PM, Kumar, Anil wrote:
> On Wed, Jan 09, 2013 at 18:17:46, Nori, Sekhar wrote:

> I do not think that it is good idea to move NAND pin mux information
> into da850.dtsi because this information is evm specific.
> if we will use this approach then we must use the same approach for
> other modules also as ASoC etc.   

Why do you consider this EVM specific. IOW, which pins do you see
changing on another board? BTW, if there are additional pins needed than
what are listed, we can always add more pinux entries in the .dts files.
The pins present in dtsi file should the base case.

Thanks,
Sekhar
