Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab1CVQs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:48:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36152 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1CVQsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:48:24 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimQ2tHwbkbd5qRgtpuzm25Hf0PEzUVQp=LKLOPu@mail.gmail.com>
References: <1300455630-21577-1-git-send-email-lucas.demarchi@profusion.mobi>
 <1300455630-21577-2-git-send-email-lucas.demarchi@profusion.mobi>
 <20110322103735.GD4448@elte.hu> <AANLkTik7wKdf_yCukg7RAAE5PWXw5YkAG=hSBuSn1wn9@mail.gmail.com>
 <20110322114405.GE4448@elte.hu> <AANLkTinqC33LE7V-2VzEJ_xnZdmokg8P7px1KP8m2DFf@mail.gmail.com>
 <20110322123357.GA14352@elte.hu> <AANLkTimQ2tHwbkbd5qRgtpuzm25Hf0PEzUVQp=LKLOPu@mail.gmail.com>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Tue, 22 Mar 2011 13:48:04 -0300
Message-ID: <AANLkTika3HadrdTDsuAei17HwVmPHOttCD=tSRtXLLLg@mail.gmail.com>
Subject: Re: [PATCH 2/4] perf: fix common misspellings
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>, jason.wessel@windriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 1:31 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> Anyway, it's all up to Linus whether he'll take a big patch.
>
> I can take a big patch, but not during the merge window when there are
> outstanding pull reqeuests etc. But possibly soon after -rc1, if it
> gets some review and I feel comfortable that the patch is clearly only
> spelling in comments (or whatever the exact rules are for codespell)

I care most about misspellings in user visible strings like docs and
printks, but there is no such distinction. In real code though changes
are usually not done (var names and the like).



Lucas De Marchi
