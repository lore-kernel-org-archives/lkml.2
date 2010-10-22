Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0JVLTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:19:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61729 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab0JVLTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:19:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] llseek conversion
Date: Fri, 22 Oct 2010 13:18:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-next-20101021+; KDE/4.5.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201010221310.08449.arnd@arndb.de> <20101022111152.GA21969@infradead.org>
In-Reply-To: <20101022111152.GA21969@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221318.36457.arnd@arndb.de>
X-Provags-ID: V02:K0:JSmY4JibThGggXjBTW0DOKbVJAa/fsPj/dUqpWdTM8X
 wjPFLyqCWnUZ4cRMl3vh8Qv9vEAvVrlTPU52fiVz/W/TrX/7Fc
 bb2+CgCB9G3Ldoho5PPtHpGviV0bR88ADO6TSNOhHDXhED8pvi
 A8s64ebmd8AMs2JZPvAExW+y/38X3ZuJO+3WGCfH9/aSkvCPXM
 oM+8a9PxOc0osOT/KtgQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 October 2010 13:11:53 Christoph Hellwig wrote:
> On Fri, Oct 22, 2010 at 01:10:08PM +0200, Arnd Bergmann wrote:
> > There are a few new drivers in linux-next that introduce additional
> > file_operations. These can all use no_llseek and I can follow up
> > with a patch to make that explicit when they get merged.
> 
> I don't think there's any reason to make that explicit.  In fact once
> your transition has settled we can just kill no_llseek.

Fair enough.

I thought about leaving out all no_llseek instances right away, but I
left them in because that allowed me to verify that my script actually
caught every single instance.

	Arnd
