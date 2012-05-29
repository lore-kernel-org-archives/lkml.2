Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2E2IRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:17:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35087 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2E2IRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 04:17:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120529175438.0e68273020662870497d8201@canb.auug.org.au>
References: <CAMuHMdVv+g=+A1HHNmWWcsFBQjRXNNA437V6-g80cYq7zRJ78g@mail.gmail.com>
 <1338275703-28103-1-git-send-email-eyal@wizery.com> <20120529175438.0e68273020662870497d8201@canb.auug.org.au>
From: Eyal Shapira <eyal@wizery.com>
Date: Tue, 29 May 2012 01:16:43 -0700
X-Google-Sender-Auth: xkL_qRvKgMHypEgK2tsd8I6X650
Message-ID: <CAF8O4-x+d8_Aq-CBcpdnmdAnuV=6V9bs4kgeNKEHAbZjWM_4-Q@mail.gmail.com>
Subject: Re: [PATCH] wlcore: fix undefined symbols when CONFIG_PM is not defined
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2012 00:54, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Eyal,
>
> On Tue, 29 May 2012 00:15:03 -0700 Eyal Shapira <eyal@wizery.com> wrote:
>>
>> commit 5063c201d7b799d6cb36d3edfc2c2c3db3b400e5
>> "wl12xx: add RX filters ACX commands" breaks the build
>> when CONFIG_PM isn't defined:
>
> Just wondering what this applies to as there is no such commit (SHA1) in
> linux-next.  Ah, actually this is commit c21eebb50379 in Linus' tree.

Stephen - you're right. The commit I've referenced refers to Luca's repo
and not linux-next. I'll send a v2 with the correct commit.
Thanks

>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
