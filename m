Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1KWU30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:29:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54746 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab1KWU3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:29:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL pm/for-next] pm: freezer update
Date: Wed, 23 Nov 2011 21:32:12 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20111123175112.GE29639@google.com>
In-Reply-To: <20111123175112.GE29639@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111232132.12716.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 23, 2011, Tejun Heo wrote:
> Hello, Rafael.
> 
> This is pull request for the following pending patches[ets].  Let's
> see if it sticks this time. :)
> 
>  [1] freezer: fix various bugs and simplify implementation, take#2
>  [2] usb_storage: don't use set_freezable_with_signal()
>  [3] dmatest: don't use set_freezable_with_signal()
>  [4] freezer: kill unused set_freezable_with_signal()
>  [5] freezer: fix wait_event_freezable/__thaw_task races
> 
> The patches are available in the git repository at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-freezer

Pulled and merged into linux-pm/linux-next.

Thanks,
Rafael
