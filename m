Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab2FDKHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:07:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48228 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab2FDKHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:07:11 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.31.133]
In-Reply-To: <81C3A93C17462B4BBD7E272753C10579232F4FBCF7@EXDCVYMBSTM005.EQ1STM.local>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
 <1337693217-15466-4-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=Wgbbdjf_SnbxQJd04nPSFBbHQQwO5zP_gW_jTiJyj_rn63g@mail.gmail.com> <81C3A93C17462B4BBD7E272753C10579232F4FBCF7@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 4 Jun 2012 13:06:50 +0300
Message-ID: <CAK=Wgba1SGzpoHhGcytoO3+zOkJ+92oZfwENZaWdfEzp7BTLNg@mail.gmail.com>
Subject: Re: [RFC 3/6] remoteproc: Move fw sanity check to find_rsc_table.
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

On Mon, Jun 4, 2012 at 12:56 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> The sanity_check() is working on the ELF structures. And all ELF
> processing needs to be moved to a separate file. So if you want
> to keep the call to sanity_check() here, I need to make the
> sanity_check() function a separate handler. That could make sense,
> but will also bloat the struct rproc_fw_ops with one more function
> pointer.

I think it's OK.

Adding another handler is cheap, and if by doing so the code becomes
even slightly easier to read or maintain, it's probably worth it.

Thanks,
Ohad.
