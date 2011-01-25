Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1AYMGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:06:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49984 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1AYMGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:06:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Hendry <andrew.hendry@gmail.com>
Subject: Re: [PATCH 4/4] BKL: move CONFIG_BKL to staging
Date: Tue, 25 Jan 2011 13:06:03 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <1295385422-3592-1-git-send-email-arnd@arndb.de> <201101241659.03071.arnd@arndb.de> <AANLkTik-3k1jQstYhxR7nv6+t2MMFei9ppthKBXF4AX8@mail.gmail.com>
In-Reply-To: <AANLkTik-3k1jQstYhxR7nv6+t2MMFei9ppthKBXF4AX8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101251306.03405.arnd@arndb.de>
X-Provags-ID: V02:K0:QSHie0fVDSo+ODbgTLKzFqnQVoXtqdVmtA1NBb/R4Yg
 O58j6wd3IWff1UH7cwtVELobdhhU8CWpAVn7/GSkaTrtQNkLcM
 kaUKm9anw6C/1/Rlz4Bbj7nNhElAEMOfYX7SssoWCyzwCUw0gv
 bz4QJscB9VQoxF1d1INVe7XfEh178RDtOaR3NcCsU2NDpgLP3Z
 0UV9urVOK+Bj/8SkX/UvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 January 2011, Andrew Hendry wrote:
> Might be looking in the wrong spot, but I can't see recent x.25
> changes at http://git.kernel.org/?p=linux/kernel/git/arnd/bkl.git
> If that is current make sure to pickup the previous x.25 bkl patches
> submitted in december via net-next to avoid duplicate effort.

It's in the "final" branch:

http://git.kernel.org/?p=linux/kernel/git/arnd/bkl.git;a=shortlog;h=refs/heads/final
http://git.kernel.org/?p=linux/kernel/git/arnd/bkl.git;a=commitdiff;h=a16147906a479dda4628fc52febd49db526699d5

	Arnd
