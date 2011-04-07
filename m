Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab1DGTru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:47:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55035 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826Ab1DGTrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:47:48 -0400
MIME-Version: 1.0
In-Reply-To: <20110407193103.GC28209@elte.hu>
References: <20110331032307.GA27999@vigoh> <20110331062949.GA29526@elte.hu>
 <20110331144400.GA2618@vigoh> <BANLkTin76790Y=6Q8vmq92b_4+7f+hzWZQ@mail.gmail.com>
 <BANLkTikDc0o6Kf5Ym5XkmpeY54fPc67SVw@mail.gmail.com> <BANLkTi=SZ_h5OpHpR7oa=+in51UciJA+UA@mail.gmail.com>
 <20110407191928.GA26693@elte.hu> <20110407193103.GC28209@elte.hu>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 7 Apr 2011 16:47:28 -0300
Message-ID: <BANLkTimt1pAkL1LJTCtWkjKk29C=NcAS-w@mail.gmail.com>
Subject: Re: [GIT PULL] Fix common misspellings
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        lucas.de.marchi@gmail.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 4:31 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Ok, i went over the commit with a fine comb again and these were the ones i was
> able to find.

Thanks a lot. It seems now I have some work to do in codespell so
these do not appear anymore.


>
> Btw., funniest typo was a typo in a changelog entry, which changelog entry
> itself was about fixing a typo:
>
>        - Tiny (mispelling->misspelling) fixed (ABORT instead of ABRT). Was fortunately

The funniest typo I found was one I fixed before sending the patch
(thanks to Phillip Lougher [http://lkml.org/lkml/2010/9/2/577]):

Documentation/DocBook/kernel-hacking.tmpl:
    /*
    * Sun people can’t spell worth damn. “compatability” indeed.
    * At least we *know* we can’t spell, and use a spell-checker.
    */


In final patch there were 31 misspellings for "compatibility" in kernel tree :-)



Lucas De Marchi
