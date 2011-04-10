Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab1DJLuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 07:50:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46472 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1DJLus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 07:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dKsFnSIbVL/WRAMs/WDGAJY/D5yAmBOzUv57KyRRs5K12B/x3Zwq6IQpFFir37evdh
         pZDIU5ZZafbPx2rz8dY7UgjUitrpFzmWTqAJe6V+ngURQ0wIqGc6T+craZ+ioGtS1DVs
         CjNQ41UgTpgg37tyJqnZAkUwThgdQlvyW+KDE=
MIME-Version: 1.0
In-Reply-To: <4DA18866.5080106@parallels.com>
References: <4D9F1F43.6030903@parallels.com>
	<BANLkTimuta=mSsQEK82HAQC0eBqfnp75uw@mail.gmail.com>
	<4DA14710.7020407@parallels.com>
	<BANLkTikhWWxEHNOpsyQBVzJ6UqFSVpFxJQ@mail.gmail.com>
	<4DA18866.5080106@parallels.com>
Date: Sun, 10 Apr 2011 13:50:46 +0200
X-Google-Sender-Auth: GTWl3_V1ktGO6ZyaWhiG0Drk1rs
Message-ID: <BANLkTi=WyvKekVKVwZVuW3CLTcYNtQOCVA@mail.gmail.com>
Subject: Re: OLS 2010 papers finally indexed.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rlandley@parallels.com>
Cc: anish singh <anish198519851985@gmail.com>,
        =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Hutton <ajh@steamballoon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 10, 2011 at 12:37, Rob Landley <rlandley@parallels.com> wrote:
> On 04/10/2011 03:26 AM, anish singh wrote:
>>
>>
>> On Sun, Apr 10, 2011 at 11:28 AM, Rob Landley <rlandley@parallels.com
>> <mailto:rlandley@parallels.com>> wrote:
>>
>>     On 04/09/2011 11:57 PM, Américo Wang wrote:
>>     > On Fri, Apr 8, 2011 at 10:44 PM, Rob Landley
>>     <rlandley@parallels.com <mailto:rlandley@parallels.com>> wrote:
>>     >> FYI, the individual papers, with their abstracts, are linked from:
>>     >>
>>     >>  http://kernel.org/doc/ols/2010
>>     >>
>>     >
>>     > Nice work, Rob! Thanks a lot!
>>
>>     You're welcome.
>>
>>     I don't suppose anybody knows where the missing papers _are_?
>>
>>     For example, a google search for "Coverage and profiling for realtime
>>     tiny kernels" brought up two legacy organizations that locked the paper
>>     away in a vault and then buried it in a sea trench:
>>
>>      http://portal.acm.org/citation.cfm?id=1900726.1901172
>>      http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=5577998
>>
>> Rob just wanted to know if you had contacted the authors of above
>> article to publish it in kernel.org <http://kernel.org>?
>
> Not yet, I was still hoping Andrew Hutton would get back to me with the
> actual final proceedings.  (Presumably they had a final file at some
> point go to the printer.)

Perhaps it helps putting Andrew in Cc (done)?

> According to the CFP, OLS papers are freely redistributable:
>
>  http://www.linuxsymposium.org/2010/cfp.php
>
>  "Authors retain copyright to all submitted papers, but have granted
>  unlimited redistribution rights to all as a condition of submission."
>
> So mirroring them on kernel.org doesn't require additional permission.
> But that's assuming they're sourced from OLS.  Sourcing the papers from
> somewhere else, I'm not sure it's the same version covered by the same
> license, so it's more work for me to confirm that stuff instead of
> relying on a blanket license from a single source.
>
>> If you have not then i can contact them (they work in my organisation)
>> and would request them to contribute in kernel.org <http://kernel.org>.
>
> Yes please.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
