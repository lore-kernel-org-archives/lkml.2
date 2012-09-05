Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab2IEXrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:47:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28088 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2IEXrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:47:36 -0400
X-AuditID: cbfee60c-b7f356d000003b01-f3-5047e4958a49
Date: Wed, 05 Sep 2012 23:47:33 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH -next] extcon: extcon-arizona depends on INPUT
To: Greg KH <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120905234542802@myungjoo.ham
Msgkey: 20120905234542802@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120905234542802@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <6721797.222311346888851339.JavaMail.weblogic@epml19>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t/tmbpTn7gHGDS32Fpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MXdP3sBZMYK/4vWsZSwPjF7YuRk4OIQF1iUVLTgLZHBwSAiYS
	G86qgYQlBMQkLtxbDxTmAiqZzyhx6vlkRpAaFgEViV0XFUBMNgE9iZmfk0HKhQXcJP5t/gQ2
	UUQgQWLetceMIK3MAj8ZJZqenGOBWKUksWbfKzCbV0BQ4uTMJywQu1Qlbs/oZoeIq0n0tWxj
	hIhLSMyafoEVwuaVmNH+FKpeTmLa1zXMELa0xPlZGxhhbl78/TFUnF/i2O0dTBBv8Uo8uR8M
	M2b3ZojPJQQEJKaeOcgIUaIl8eaMOUSYT2LNwrcsMFN2nVrODNN6f8tcJhCbWUBRYkr3Q3YI
	W0viy499bOi+4hVwlDj6/yjLBEa5WUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9FQjveLE3OLS
	vHS95PzcTYzgCH/Gs4NxToPFIUYBDkYlHt5f+e4BQqyJZcWVuYcYJTiYlUR4V3cDhXhTEiur
	Uovy44tKc1KLDzFKc7AoifN+9vrqLySQnliSmp2aWpBaBJNl4uCUamDk28bFezf3cySfoVJ0
	u+ZH5k/zNf4b2cTO9E7R2X25fJPuuvlLuydJ1ejaFivef+oZITSjl99e1VXRXO7OzrBEZpWy
	gifX29ZPElcWFC+Pnvr0y4K9C/8vWObMf+Hd6/t739wtvPDMZMYc5YlK/vc2tbUdMAq64XM7
	T0LvtOH3qL9scpLnuvyUWIozEg21mIuKEwH0aswP7AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q85Nlgle020748

> On Wed, Sep 05, 2012 at 11:28:03AM +0800, Mark Brown wrote:
> > On Tue, Sep 04, 2012 at 04:51:00PM -0700, Randy Dunlap wrote:
> > 
> > > This build error still happens in linux-next of 20120904.
> > 
> > > Can we get the patch merged for linux-next?
> > 
> > Greg's the one managing extcon in -next.
> 
> Yeah, can someone forward this to me so I can apply it?  I can't seem to
> find it anywhere...
> 
> greg k-h

I've been creating "extcon-for-next" tree at git.infradead.org
I'll rebase the branch base on your driver-core-next

http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next


Cheers!
MyungJooˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
