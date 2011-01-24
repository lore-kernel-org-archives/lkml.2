Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1AXP7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:59:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1AXP7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:59:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Hendry <andrew.hendry@gmail.com>
Subject: Re: [PATCH 4/4] BKL: move CONFIG_BKL to staging
Date: Mon, 24 Jan 2011 16:59:02 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <1295385422-3592-1-git-send-email-arnd@arndb.de> <20110119182142.GA3620@elliptictech.com> <AANLkTimOzU328aHnB7+ERSq1ovPBSZgxNQsYRhLghH5L@mail.gmail.com>
In-Reply-To: <AANLkTimOzU328aHnB7+ERSq1ovPBSZgxNQsYRhLghH5L@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101241659.03071.arnd@arndb.de>
X-Provags-ID: V02:K0:pTHnAC6z3N+MQwHZgwjqJ/MW7I06awS8ZrcFt2KZuCv
 Wex+xSy1tTxKzsAsJhINx97sFe1qglkXhrqMO5DmWlkmczGgS3
 YI6jxIMJbh/2n5FFWLMHHvdZFVavkb3gKMwHrAjvnqL0IbyMBR
 FjsaCmiU2XOgcPTQ4yhECvtmViul7/gmh1j3Tr/kfVfTkQ3QPz
 GFSSpbUi8dQX5NGKt4x1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 January 2011, Andrew Hendry wrote:
> Most the x.25 BKLs have patches accepted over the past few months.
> There are 3 remaining in send, recieve and destroy that I haven't had time
> to work through. If anyone wants to take a look at them I can help test, but
> I wont have time until march to focus on them myself.

I've given it a try on the weekend, see my bkl.git tree on kernel.org.
I have patches for everything except IPX and UFS now, the latter was
giving me a hard time but I think I'm getting close there. IPX
should not be too hard.

	ARnd
