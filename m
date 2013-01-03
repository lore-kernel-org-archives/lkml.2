Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3ACGOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:14:46 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:55241 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3ACGOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:14:44 -0500
Message-ID: <1357193665.3924.38.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 03 Jan 2013 17:14:25 +1100
In-Reply-To: <1357193608.3924.37.camel@pasglop>
References: <1357193608.3924.37.camel@pasglop>
Organization: IBM Australia
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010306-0260-0000-0000-0000025BB775
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 17:13 +1100, Benjamin Herrenschmidt wrote:
> Hi Linus !
> 
> Here are a couple of small powerpc fixes. They aren't new bugs (and
> they are both CCed to stable) but I didn't see the point of sitting
> on the fixes any longer.

Looks like I still need to fix my script to get the branch name right
for when the mirrors haven't caught up...

It's

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Cheers,
Ben.

