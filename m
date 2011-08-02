Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1HBTdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:33:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63208 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab1HBTdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:33:12 -0400
MIME-Version: 1.0
In-Reply-To: <4E38510B.6090001@suse.cz>
References: <1311634718-32588-1-git-send-email-mmarek@suse.cz>
	<1311947497-4958-1-git-send-email-mmarek@suse.cz>
	<20110802173343.GA5251@merkur.ravnborg.org>
	<CACqU3MUy_EBaVB_VHW0EcbMcV9Qn_H=oh4ZKkCaUuPtbezpC4A@mail.gmail.com>
	<20110802192610.GA5338@merkur.ravnborg.org>
	<4E38510B.6090001@suse.cz>
Date: Tue, 2 Aug 2011 15:33:09 -0400
Message-ID: <CACqU3MUBA=C-1sP8_PyHFy-wKLAiLFXTxdU61c7SUxFuQ+fFbw@mail.gmail.com>
Subject: Re: [PATCH] kconfig: Introduce IS_ENABLED(), IS_BUILTIN() and IS_MODULE()
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
        xiyou.wangcong@gmail.com, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 2, 2011 at 3:33 PM, Michal Marek <mmarek@suse.cz> wrote:
> Dne 2.8.2011 21:26, Sam Ravnborg napsal(a):
>>>>
>>>> If we do it like this then how about adding this to autoconf.h and avoid the extra file,
>>>> and the extra flag to gcc?
>>>>
>>> That would be intrusive for non-Linux users of kconfig. You would have
>>> to hardcode a <linux/kconfig.h> in autoconf.h, which mean other
>>> project would have to either mirror the Linux include tree structure,
>>> or modify kconfig for the desired include path, if the feature is
>>> desired at all. As I see it, Linux, through Kbuild, is a user of
>>> kconfig.
>> The idea was to entirely skip kconfig.h - and include the code in
>> autoconf.h verbatim - so no extra file.
>
> We could do that. I went for the extra file because it was easier to
> edit a .h file than to edit a .c file that generates a .h file :).
>
seconded :)

 - Arnaud
