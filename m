Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2GBPTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:19:41 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37224 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2GBPTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:19:39 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.43.174]
In-Reply-To: <81C3A93C17462B4BBD7E272753C10579232F86BE4C@EXDCVYMBSTM005.EQ1STM.local>
References: <1337687472-23009-1-git-send-email-ohad@wizery.com>
 <4FBDFC4A.1060602@codeaurora.org> <CAK=WgbaP5qSso_Eu=Oup4eqLDcorZ-qf=mysMKiEvOS=m7yLmg@mail.gmail.com>
 <4FCD276A.80505@codeaurora.org> <CAK=WgbZo-8GXY9bVYGk0XZvqKrdaJZWeNkK1FhRWnH5doGYLjA@mail.gmail.com>
 <CAK=WgbZb367zq0QCUuwFU+KtBY0gw_+rsN9fm2YnM-heT+54jA@mail.gmail.com> <81C3A93C17462B4BBD7E272753C10579232F86BE4C@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 2 Jul 2012 18:19:18 +0300
Message-ID: <CAK=WgbYG8kuzYUi54Kh4udsrOiX_f1E=1XW+TpeYhoyPtXwq-w@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: block premature rproc booting
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 6:15 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
>> Sjur, Ludovic, Loic - what remoteproc API are you using today?
>>
>> We'd like to get rid of the existing get/put interface and instead
>> have everyone use the boot/shutdown one, just like rpmsg is doing
>> today.
>>
>> Are you ok with this change?
>
> Yes, I'm ok with this,
> but I cannot answer for Loic and Ludovic.

Thanks, Sjur.

I think Ludovic and Loic should be ok with this because their use
cases are very much like OMAP's (mostly rpmsg drivers).

Ohad.
