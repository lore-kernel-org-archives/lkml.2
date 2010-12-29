Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab0L2MJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 07:09:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34948 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab0L2MJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 07:09:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: Linux 2.6.37-rc8
Date: Wed, 29 Dec 2010 13:08:58 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com> <20101229111840.GA13498@a1.tnic>
In-Reply-To: <20101229111840.GA13498@a1.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012291308.58676.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 29, 2010, Borislav Petkov wrote:
> On Tue, Dec 28, 2010 at 05:18:12PM -0800, Linus Torvalds wrote:
> > Another week, another -rc. This should be the last for the 37 series,
> 
> There's also the issue with oopsing when physically removing the battery
> from the system. I have a proposed fix but no acks/nacks from ACPI guys
> yet:
> 
> https://patchwork.kernel.org/patch/418751/

The commit causing this problem has been reverted:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cde44d1740bcb3dcfecbf792a71826431e61686e

Which means that the problem it attepmted to address is back.

Thanks,
Rafael
