Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0LIIGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 03:06:24 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62268 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab0LIIGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 03:06:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=k1kz1CKotEa0IUDtpkhSwUJc5tHcxnveRgw0CXRQzGvckVpZgoRkOlxyOFXK376Bfu
         c4uTcnCdWsUmm1swh7MfRQBZaYyiKxvpQEY/QOG+YeTgcLvXsr48d7DUKCgFAvZ8o2jI
         QueTvK2cn87TAZHdE/Y1Y9soncZT+36uGxdxo=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 9 Dec 2010 09:06:22 +0100
Message-ID: <AANLkTim9P7vpxLOPcRUeEyhe3g4PATK6Fq5UqN3KW6iA@mail.gmail.com>
Subject: Re: linux-next: Tree for December (Reverts in tip tree)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while looking over Stehen's "ChangeLog" from [1]:

"...The tip tree still has its build failures so I have reverted 3 commits..."

This are the patches:

Revert "perf, arch: Cleanup perf-pmu init vs lockup-detector"
Revert "x86, nmi_watchdog: Remove the old nmi_watchdog"
Revert "x86, nmi_watchdog: Remove all stub function calls from old nmi_watchdog"

The first time they have to be reverted was in next-20101130 [2].
Just curious, Is this going to be fixed?
Are there patches around for testing?
Don't misunderstand me, the solution is not vitally important to me :-).

Regards,
- Sedat -

[1] http://lkml.org/lkml/2010/12/8/517
[2] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=shortlog;h=refs/tags/next-20101130
