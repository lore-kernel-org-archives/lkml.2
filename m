Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608Ab2FDKB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:01:27 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65282 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2FDKBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:01:25 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.31.133]
In-Reply-To: <81C3A93C17462B4BBD7E272753C10579232F4FBCFD@EXDCVYMBSTM005.EQ1STM.local>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
 <1337693217-15466-3-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbafpAC+DZ71Oon_PyiWGAryAxzZvttpeiFY+A_agYcMFw@mail.gmail.com>
 <CAK=WgbZXHvTQmQZ3Y9ZBLREmsfZx4Bk8Y-H42_1c_j3ZFSqgPQ@mail.gmail.com> <81C3A93C17462B4BBD7E272753C10579232F4FBCFD@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 4 Jun 2012 13:01:04 +0300
Message-ID: <CAK=Wgbad=+wv0iVJ-Vx05rh12UrwghyCzsM26XM2sbzrYzXtVA@mail.gmail.com>
Subject: Re: [RFC 2/6] remoteproc: Pass struct fw to load_segments and find_rsc_table.
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 4, 2012 at 12:58 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> This value is not used anywhere in the upstream code. Couldn't we
> just delete this, and you can add it when you upstream the code
> where this is used?

We must have it for OMAP's and DaVinci's DSPs - the relevant patch is
coming up very soon now, so let's please keep this intact.

Thanks,
Ohad.
