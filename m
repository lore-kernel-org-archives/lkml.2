Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab1ANSOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:14:34 -0500
Received: from mail.atmel.fr ([81.80.104.162]:50810 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757071Ab1ANSO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:14:28 -0500
Message-ID: <4D309278.5010603@atmel.com>
Date: Fri, 14 Jan 2011 19:14:16 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Igor Plyatov <plyatov@gmail.com>, Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Subject: Re: [GIT PULL] AT91: patches for v2.6.38-rc1
References: <4D308F30.6070503@atmel.com> <20110114180455.GL15996@n2100.arm.linux.org.uk>
In-Reply-To: <20110114180455.GL15996@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/01/2011 19:04, Russell King - ARM Linux :
> On Fri, Jan 14, 2011 at 07:00:16PM +0100, Nicolas Ferre wrote:
>> Hi Russell,
>>
>> Can you please pull those little changes for AT91? They add two 
>> new boards already discussed on the mailing list and a little 
>> cleanup patch:
> 
> Has this already been in linux-next?

I must admit that... no.

> We should only be merging new code during a merge window which has
> already had visibility in linux-next, with the exception of bug fixes
> and regression fixes.

I understand your point but those are only *board* files that are lying
around for one or two months.
I was really wishing to see them included in mainline during merge
window as they are not core ARM nor AT91 files...

BTW the git tree is based on the tree you specify to Eric: "9e9bc973".

> Regression fixes can be merged at any time provided they're obvious.
> Any regression fix should be acceptable during the merge window.
> 
> Bug fixes any time up until (I'd say) the last week of the -rc series.

Best regards,
-- 
Nicolas Ferre
