Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab2AMT1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:27:37 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53124 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2AMT1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:27:33 -0500
MIME-Version: 1.0
In-Reply-To: <7vaa5rzaax.fsf_-_@alter.siamese.dyndns.org>
References: <20120109073727.GF22134@opensource.wolfsonmicro.com>
 <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com>
 <20120110184530.GE7164@opensource.wolfsonmicro.com> <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com>
 <20120110222711.GK7164@opensource.wolfsonmicro.com> <CA+55aFxvQF=Bm4ae6euB_UO8otMCuN9Lv37Zn3TpE-L7JH3Kzw@mail.gmail.com>
 <20120111184026.GA23952@windriver.com> <7vaa5rzaax.fsf_-_@alter.siamese.dyndns.org>
From: Nguyen Thai Ngoc Duy <pclouds@gmail.com>
Date: Sat, 14 Jan 2012 02:27:01 +0700
Message-ID: <CACsJy8BmFgssTAh=1U7JgBsGG-tSaWXQzZeODND3icXY3QUxug@mail.gmail.com>
Subject: Re: [PATCH] merge: Make merge strategy message follow the diffstat
To: Junio C Hamano <gitster@pobox.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 2:12 AM, Junio C Hamano <gitster@pobox.com> wrote:
> Paul Gortmaker <paul.gortmaker@windriver.com> writes:
>
>> By moving the message after the diffstat, there is a better chance that
>> people will be aware they've done a pointless merge commit.
>>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>
> I think the goal of the change may be worthy

Still, diffstat from a fetch/pull is sometimes too verbose. It'd be
better if we have something that fit in one screen (dirstat or maybe
just a first few lines from diffstat then ellipsis) then refer users
to "git diff --stat HEAD@{1}" for more detail stat.
-- 
Duy
