Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0KXF46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:56:58 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62841 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab0KXF4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:56:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=bF88t+0kNOaACDm2qoAfQtYo3y5wVVB+lhdu3Zt6sZg2cPy+Jq2/XUEw+2xQt6gn1Y
         I3clEFm8UlpainRNGzsx/U91ZFaYxtOsaxBu7zAnpOpnyn6BAqMNTHtMiIcyDfWGPdTg
         RjcbA44qhrjpp54ZJp6882A3gnBKSpT+IZb6w=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 24 Nov 2010 06:56:53 +0100
Message-ID: <AANLkTin_Cd8_LLt2qizmMTgsC2nixr4Nb-yeKyL5gYEg@mail.gmail.com>
Subject: Re: linux-next: Tree for November 24 (drm/drm-next)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: sfr@canb.auug.org.au
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it does not look like the recent drm-2.6/drm-next commits [1] were
pulled into linux-next.
These commits are 30hrs vs. [2] is 3hrs young.
Also the merge.log [3] shows no drm hits.
Forgot to pull in?

Regards,
- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=shortlog;h=refs/heads/drm-next
[2] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=shortlog
[3] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=Next/merge.log;h=12a8df5cf3aa4d51798e26160e7312efda88b065;hb=bd59982e813e8bf45901f6ba216f600cddcbc25a
