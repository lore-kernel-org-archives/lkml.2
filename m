Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2LZBzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:55:24 -0500
Received: from intranet.asianux.com ([58.214.24.6]:8986 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2LZBzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:55:21 -0500
X-Spam-Score: -100.8
Message-ID: <50DA593E.9000707@asianux.com>
Date: Wed, 26 Dec 2012 09:56:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/staging/tidspbridge: pr_err and pr_debug
 for uninitialized buffer (name buf not initialized).
References: <50C85644.7020203@asianux.com> <50C858AA.8080305@asianux.com> <CAJ6Av5OC+2wdfhb2FExv8NM7Hsyu4_1qnCWV22di8_psw4gF4Q@mail.gmail.com> <50CA8129.2020206@asianux.com> <CAJ6Av5PqZoW7s94J6MfmiN6kLzYZHH5Cv6qBA+xq65aPO0KA7g@mail.gmail.com>
In-Reply-To: <CAJ6Av5PqZoW7s94J6MfmiN6kLzYZHH5Cv6qBA+xq65aPO0KA7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年12月24日 22:26, Omar Ramirez Luna 写道:
>>       b: version merging issue:
>> >         in drivers/staging/tidspbridge/core/_tiomap.h
>> >         need use "#include <mach-omap2/cm3xxx.h>" instead of "#include <mach-omap2/cm2xxx_3xxx.h>"
>> >         the macro OMAP3430_CM_AUTOIDLE_PLL has already move from cm2xxx_3xxx.h to cm3xxx.h.
>> >           (it seems arch/arm/mach-omap2/ is not a suitable place for including, but we have to)
>> >         if not change, compiling will be failed.

  also please help checking this issue, thanks.

-- 
Chen Gang

Asianux Corporation
