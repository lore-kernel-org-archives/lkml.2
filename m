Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab2IGB63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 21:58:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53398 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab2IGB61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 21:58:27 -0400
From: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel@ffwll.ch
Subject: Re: Re: 3.4.10 i915 [GM45] regression
Date: Fri, 07 Sep 2012 03:57:54 +0200
Message-ID: <2329337.9aFzn0oRxF@tux200s>
Organization: Andreas Sturmlechner
User-Agent: KMail/4.9.1 (Linux/3.5.3-ownage; KDE/4.9.1; x86_64; ; )
In-Reply-To: <20120907011542.GA26688@kroah.com>
References: <2372445.fuIXicT4H0@tux200s> <20120907011542.GA26688@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Sep 07, 2012 at 02:27:12AM +0200, Andreas Sturmlechner wrote:
> > Hello,
> > 
> > please revert commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 - for some 
> > reason it breaks boot-up (screen stays blank) on my GM45 hardware despite 
> > >= 3.5 being fine.
> > 
> > See bug 54575 on freedesktop.org for a full description: 
> > https://bugs.freedesktop.org/show_bug.cgi?id=54575
> > 
> > No idea how far-spread or not this might be since I couldn't find any
> > other reports of that kind.
> 
> Can you cc: this to the people who wrote that patch?  That might help in
> figuring out what is wrong here...
> 
> thanks,
> 
> greg k-h

done as intended, hopefully
