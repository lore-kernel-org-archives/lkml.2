Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725Ab2KBVrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:47:14 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53151 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758662Ab2KBVrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:47:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Suspend/resume without VT switches
Date: Fri, 02 Nov 2012 22:51:07 +0100
Message-ID: <7608326.fQBj17U8Wv@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1351892621-4840-1-git-send-email-jbarnes@virtuousgeek.org>
References: <1351892621-4840-1-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 02, 2012 02:43:39 PM Jesse Barnes wrote:
> I've lightly tested this with X and it definitely makes my
> suspend/resume sequence a bit prettier.  It should speed things up
> trivally as well, but most of those gains come from other changes to the
> i915 driver (posted earlier to intel-gfx).
> 
> Any thoughts?

I like the idea.

> I suspect we'll have to be more defensive about the
> resume configuration in case the BIOS did something weird, but overall I
> think we should be able to do this one way or another.

Perhaps patch [1/2] should be [2/2] and vice versa? :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
