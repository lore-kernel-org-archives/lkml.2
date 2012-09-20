Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2ITNuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:50:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47468 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab2ITNuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:50:51 -0400
Message-ID: <505B1F37.9040305@arm.com>
Date: Thu, 20 Sep 2012 14:50:47 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual machines
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>  <1348135563.11116.94.camel@hornet>  <alpine.DEB.2.02.1209201235450.29232@kaball.uk.xensource.com>  <1348142133.11116.109.camel@hornet>  <alpine.DEB.2.02.1209201308490.29232@kaball.uk.xensource.com>  <505B0C00.5010003@arm.com> <1348147826.26501.47.camel@zakaz.uk.xensource.com>
In-Reply-To: <1348147826.26501.47.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 1.5a1pre
X-OriginalArrivalTime: 20 Sep 2012 13:50:48.0413 (UTC) FILETIME=[F097F0D0:01CD9736]
X-MC-Unique: 112092014504917701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/09/12 14:30, Ian Campbell wrote:
> On Thu, 2012-09-20 at 13:28 +0100, Marc Zyngier wrote:
>> I think the important thing here is that the memory map is RS1. As this
>> is a (very limited) subset of a vexpress A15, it seems to make some sense.
> 
> Looking at arch/arm/boot/dts/vexpress-v2m-rs1.dtsi I don't think we
> provide anything which is on rs1 though.

The location of both GIC and memory are RS1 "compliant" (as in "they are
at the expected location").

	M.
-- 
Jazz is not dead. It just smells funny...

