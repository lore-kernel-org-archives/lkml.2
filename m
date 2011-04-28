Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760414Ab1D1QYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:24:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:33659 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757739Ab1D1QYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:24:51 -0400
Message-ID: <4DB994CE.40403@suse.cz>
Date: Thu, 28 Apr 2011 18:24:46 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
Cc: Borislav Petkov <bp@alien8.de>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3.1] kbuild: implement several W= levels
References: <20110422110947.GA20715@merkur.ravnborg.org> <1303494642-18594-1-git-send-email-bp@alien8.de> <20110427082555.GC5726@merkur.ravnborg.org>            <20110427113513.GB18112@eferding.osrc.amd.com> <11802.1303950320@localhost>
In-Reply-To: <11802.1303950320@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.4.2011 02:25, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 27 Apr 2011 13:35:13 +0200, Borislav Petkov said:
>
>> If we do this inclusive, then W=2 dumps the, let's call it, level 1
>> _plus_ the new level 2 warnings, polluting the output with something
>> I've already seen, but only partially. And then I start to think, did
>> I see this one already, didn't I, which was it? By the time you enable
>> W=3, the output becomes pretty useless. For example, W=3 generates 190+
>> MB logfile here only with level 3 warnings. Now imagine all 3 levels
>> combined.
>
> If each level is averaging 10x the previous level, then all 3 levels will only be 11%
> bigger, or 211MB.
>
> You *really* want to get *all* the warnings - quite often, you'll be looking
> at a set of 15 or 20 level-3 warnings.  And if you had the Level-2's in there as
> well, you'd immediately realize that the single level-2 was the real root-cause
> of all the cascating warnings.

How about W=12 for level 1 and 2 warnings and W=123 for all levels?

Michal
