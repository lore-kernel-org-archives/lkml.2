Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0HZGqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 02:46:19 -0400
Received: from purkki.adurom.net ([80.68.90.206]:50717 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab0HZGqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 02:46:14 -0400
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Filesystem corruption with 2.6.36-rc1-wl+ and ecryptfs
References: <87tymt9iex.fsf@purkki.adurom.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 26 Aug 2010 09:46:13 +0300
In-Reply-To: <87tymt9iex.fsf@purkki.adurom.net> (Kalle Valo's message of "Tue\, 17 Aug 2010 21\:57\:10 +0300")
Message-ID: <87k4nd98i2.fsf@purkki.adurom.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kalle Valo <kvalo@adurom.com> writes:

> I just installed my first 2.6.36 kernel, 2.6.36-rc1-wl+ from
> wireless-testing, and immeadialy (during first boot) got major
> corruption in the filesystem. For example, gnome lost it's settings,
> ~/.ssh was empty etc. Now, with an older kernel, my directory
> structure has duplicate entries, like this:
>
> $ ls -ald D*
> drwxr-xr-x 2 kvalo kvalo 4096 2010-08-17 19:21 Desktop/
> drwxr-xr-x 2 kvalo kvalo 4096 2010-08-17 19:21 Desktop/
> drwxr-xr-x 2 kvalo kvalo 4096 2010-08-17 19:21 Documents/
> drwxr-xr-x 2 kvalo kvalo 4096 2010-08-17 19:21 Documents/
> drwxr-xr-x 2 kvalo kvalo 4096 2010-08-17 19:21 Downloads/
> drwxr-xr-x 2 kvalo kvalo 4096 2010-08-17 19:21 Downloads/
>
> I'm using ecryptfs and that's my major suspect for the corruption, but
> naturally I can't be sure because I'm just guessing here. 

(For the archives)

It was ecryptfs, bug report here:

https://bugs.launchpad.net/ecryptfs/+bug/623087

And fix here:

http://git.kernel.org/?p=linux/kernel/git/ecryptfs/ecryptfs-2.6.git;a=commitdiff;h=b4ef26e06ce0c4877bd5a736b0dfb318a4fb9002

-- 
Kalle Valo
