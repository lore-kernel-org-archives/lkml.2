Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab2I3LQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 07:16:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59932 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2I3LQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 07:16:22 -0400
From: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: 3.4.10 i915 [GM45] regression
Date: Sun, 30 Sep 2012 13:15:38 +0200
Message-ID: <12610424.iJ3m5UY2ZS@tux200s>
Organization: Andreas Sturmlechner
User-Agent: KMail/4.9.1 (Linux/3.6.0-rc7; KDE/4.9.1; x86_64; ; )
In-Reply-To: <20120928160656.GE2625@kroah.com>
References: <2372445.fuIXicT4H0@tux200s> <CAKMK7uFm7YVMeUKUj4wmCeV4myYYODrp2XFDn5O8PHmjg3_U4g@mail.gmail.com> <20120928160656.GE2625@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, now reverted, thanks.
> 
> greg k-h

The same patch also breaks 3.0 for me. A 3.0.42 image with the patch reverted was fine, I checked with several restarts.

Sort of confirms there is something in >=3.5 that makes this thing work.

Regards
